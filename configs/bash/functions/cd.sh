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
            echo "${index}) ${history}"
            index=$(($index + 1))
        done
    }

    __cd_jump() {
        local history_len="${#KBC_CD_HISTORY[@]}"

        if [[ $history_len -eq 0 ]]; then
            echo "History empty"
            return 2
        fi

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
    local cd_destination=
    local _flag_help=false
    local _flag_jump=false
    local _flag_list=false
    local current_dir=$(pwd)

    if [[ $# -gt 1 ]]; then
        echo "cd: Too many arguments."
        return 1
    fi

    case $1 in
    -h | --help)
        _flag_help=true
        ;;
    -l | --list)
        _flag_list=true
        ;;
    -j | --jump)
        _flag_jump=true
        ;;
    *)
        cd_destination="$1"
        ;;
    esac

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

    [[ "$current_dir" = "$cd_destination" ]] && return 0

    builtin cd -- "$cd_destination"
    local cd_status=$?

    # remove history no matter what
    # because of that history may not exist anymore
    __cd_remove_history "$cd_destination"

    [[ $cd_status -ne 0 ]] && return $cd_status

    KBC_CD_PREV="$current_dir"
    __cd_update_history "$current_dir"

    return 0
}
