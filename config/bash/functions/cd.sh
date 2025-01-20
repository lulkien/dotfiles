function cd() {
    # Global variables for this SHELL session
    declare -p KBC_CD_PREV &>/dev/null || declare -g KBC_CD_PREV=$HOME
    declare -p KBC_CD_HISTORY_LEN &>/dev/null || declare -g -i KBC_CD_HISTORY_LEN=15

    HISTORY_FILE=$HOME/.cd_history
    HISTORY_TEMP=$HISTORY_FILE.temp

    [[ ! -f $HISTORY_FILE ]] && (
        umask 077
        touch $HISTORY_FILE
    )

    __cd_print_help() {
        echo "Usage: cd [OPTION]"
        echo "  or:  cd [DESTINATION]"
        echo "Change directory to a specific path or a history index."
        echo
        echo "Options:"
        echo "    -l, --list            Show cd history list and jump."
        echo "    -h, --help            Show this help."
    }

    __cd_update_history() {

        [[ -z "$1" || "$1" = "$HOME" ]] && return

        {
            echo "$1"
            cat "$HISTORY_FILE"
        } |
            awk '!seen[$0]++' |
            head -n $KBC_CD_HISTORY_LEN |
            tee $HISTORY_TEMP >/dev/null &&
            mv $HISTORY_TEMP $HISTORY_FILE

    }

    __cd_remove_history() {

        [[ -z "$1" || "$1" = "$HOME" ]] && return

        awk -v line="$1" '$0 != line' $HISTORY_FILE |
            tee $HISTORY_TEMP >/dev/null &&
            mv $HISTORY_TEMP $HISTORY_FILE

    }

    __cd_show_jump_list() {

        if [[ ! -s "$HISTORY_FILE" ]]; then
            echo "History empty."
            return 1
        fi

        declare -a cd_history=()

        while IFS= read -r line; do
            cd_history+=("$line")
        done <$HISTORY_FILE

        COLUMNS=30
        select history_path in "${cd_history[@]}"; do

            if [[ ! "$REPLY" =~ ^[0-9]+$ ]]; then
                echo "Index must be a number."
                return 2
            fi

            if [[ "$REPLY" -lt 1 || "$REPLY" -gt "${#cd_history[@]}" ]]; then
                echo "Index out of range."
                return 2
            fi

            echo "$history_path"
            return 0

        done
    }

    # ----------------------------------- MAIN -----------------------------------
    # Variables for CD script
    local cd_destination=
    local _flag_help=false
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
    -j | -l | --jump | --list)
        _flag_list=true
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

        local jump_msg=
        local jump_err=

        jump_msg=$(__cd_show_jump_list)
        jump_err=$?

        echo "----------------------------"
        if [[ $jump_err -ne 0 ]]; then
            echo -e "\e[1;31mcd\e[00m: $jump_msg"
            return $jump_err
        fi

        cd_destination="$jump_msg"
        echo -e "\e[1;33mcd\e[00m: $cd_destination"

    else

        if [[ -z "$cd_destination" ]]; then
            cd_destination="$HOME"
        elif [[ "$cd_destination" = '-' ]]; then
            cd_destination="$KBC_CD_PREV"
            echo -e "\e[1;33mcd\e[00m: $cd_destination"
        else
            local real_path=
            real_path=$(realpath -q "$cd_destination")
            [[ $? -eq 0 ]] && cd_destination="$real_path"
        fi
    fi

    [[ "$current_dir" = "$cd_destination" ]] && return 0

    builtin cd -- "$cd_destination"
    local cd_status=$?

    # REMOVE HISTORY NO MATTER WHAT
    # BECAUSE OF THAT HISTORY MAY NOT EXIST ANYMORE
    __cd_remove_history "$cd_destination"

    [[ $cd_status -ne 0 ]] && return $cd_status

    KBC_CD_PREV="$current_dir"
    __cd_update_history "$cd_destination"

    return 0
}
