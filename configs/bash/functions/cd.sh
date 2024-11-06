function cd() {
    # Global variables for this SHELL session
    declare -p KBC_CD_HISTORY &>/dev/null || declare -g -a KBC_CD_HISTORY=()
    declare -p KBC_CD_PREV &>/dev/null || declare -g KBC_CD_PREV=$HOME
    declare -p KBC_CD_HISTORY_LEN &>/dev/null || declare -g -i KBC_CD_HISTORY_LEN=15

    __cd_print_help() {
        echo "Usage: cd [OPTION]"
        echo "  or:  cd [DESTINATION]"
        echo "Change directory to a specific path or a history index."
        echo
        echo "Options:"
        echo "    -j, --jump            Show cd jump list."
        echo "    -l, --list            Print cd history list."
        echo "    -h, --help            Show this help."
    }

    __cd_number_check() {
        [[ $@ =~ ^[0-9]+$ ]]
    }

    __cd_update_history() {
        [[ -z "$1" || "$1" = "$HOME" ]] && return

        KBC_CD_HISTORY=("$1" "${KBC_CD_HISTORY[@]}")
    }

    __cd_remove_history() {
        [[ -z "$1" || "$1" = "$HOME" ]] && return

        local new_history=()
        local history_len=0

        for item in "${KBC_CD_HISTORY[@]}"; do

            [[ "$item" = "$1" ]] && continue

            history_len=$(($history_len + 1))

            [[ $history_len -ge $KBC_CD_HISTORY_LEN ]] && break

            new_history+=("$item")
        done

        KBC_CD_HISTORY=("${new_history[@]}")
    }

    __cd_print_list() {
        local index=1
        for history in "${KBC_CD_HISTORY[@]}"; do
            echo "${index} - ${history}"
            index=$(($index + 1))
        done
    }

    __cd_jump() {
        local history_len="${#KBC_CD_HISTORY[@]}"

        COLUMNS=30
        select history_dir in "${KBC_CD_HISTORY[@]}"; do

            if [[ ! "$REPLY" =~ ^[0-9]+$ ]]; then
                echo "Index must be a number."
                return 2
            fi

            if [[ "$REPLY" -lt 1 || "$REPLY" -gt $history_len ]]; then
                echo "Index out of range."
                return 2
            fi

            echo "$history_dir"
            return 0
        done
    }

    # ----------------------------------- MAIN -----------------------------------
    # Variables for CD script
    cd_destination=
    _flag_help=false
    _flag_jump=false
    _flag_list=false
    argument_count=0

    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            _flag_help=true
            argument_count=$(($argument_count + 1))
            ;;
        -l | --list)
            _flag_list=true
            argument_count=$(($argument_count + 1))
            ;;
        -j | --jump)
            _flag_jump=true
            argument_count=$(($argument_count + 1))
            ;;
        *)
            cd_destination="$1"
            argument_count=$(($argument_count + 1))
            ;;
        esac
        shift
    done

    if [[ $argument_count -gt 1 ]]; then
        echo "cd: Too many arguments."
        return 1
    fi

    if $_flag_help; then
        __cd_print_help
        return 0
    fi

    if $_flag_list; then
        __cd_print_list
        return 0
    fi

    if $_flag_jump; then
        local jump_msg=
        local jump_err=

        jump_msg=$(__cd_jump)
        jump_err=$?

        if [[ $jump_err -ne 0 ]]; then
            echo "cd: $jump_msg"
            return $jump_err
        fi

        cd_destination="$jump_msg"
        echo "----------------------------"
        echo -e "\e[1;33mcd\e[00m: $cd_destination"
    else

        if [[ -z "$cd_destination" ]]; then
            cd_destination="$HOME"
        elif [[ "$cd_destination" = '-' ]]; then
            cd_destination="$KBC_CD_PREV"
        else
            local real_path=
            real_path=$(realpath -q "$cd_destination")
            [[ $? -eq 0 ]] && cd_destination="$real_path"
        fi
    fi

    local current_dir=$(pwd)
    [[ "$current_dir" = "$cd_destination" ]] && return 0

    builtin cd -- "$cd_destination"

    if [[ $? -eq 0 ]]; then
        __cd_remove_history "$cd_destination"
        KBC_CD_PREV="$current_dir"
        __cd_update_history "$current_dir"
    fi

    return $cd_status
}
