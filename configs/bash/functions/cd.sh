cd() {
    # Global variables for this SHELL session
    declare -p BASH_CD_HISTORY &>/dev/null || export BASH_CD_HISTORY=
    declare -p BASH_CD_PREV &>/dev/null || export BASH_CD_PREV=$HOME
    declare -p BASH_CD_HISTORY_LEN &>/dev/null || export BASH_CD_HISTORY_LEN=15

    __cd_print_help() {
        echo "Usage: cd [OPTION]"
        echo "  or:  cd [DESTINATION]"
        echo "Change directory to a specific path or a history index."
        echo
        echo "Options:"
        echo "    -i, --index=index     Jump to INDEX of history"
        echo "    -l, --list            Print cd history list"
        echo "    -h, --help            Show help"
    }

    __cd_number_check() {
        [[ $@ =~ ^[0-9]+$ ]]
    }

    __cd_update_history() {
        local path=$1

        if [[ -z "$path" ]] || [[ "$path" = "$HOME" ]]; then
            return
        fi

        if [[ -z "$BASH_CD_HISTORY" ]]; then
            BASH_CD_HISTORY=$path
        else
            BASH_CD_HISTORY=$path:$BASH_CD_HISTORY
        fi
    }

    __cd_remove_history() {
        local path=$1
        if [[ -z "$path" ]] || [[ "$path" = "$HOME" ]]; then
            return
        fi

        local history_paths=
        local history_len=0

        IFS=: read -r -a history_paths <<<"$BASH_CD_HISTORY"
        BASH_CD_HISTORY=

        for history in "${history_paths[@]}"; do

            if [[ $history = $path ]]; then
                continue
            fi

            history_len=$(($history_len + 1))
            if [[ $history_len -ge $BASH_CD_HISTORY_LEN ]]; then
                break
            fi

            if [[ -z "$BASH_CD_HISTORY" ]]; then
                BASH_CD_HISTORY=$history
            else
                BASH_CD_HISTORY=$BASH_CD_HISTORY:$history
            fi
        done
    }

    __cd_print_history() {
        local index=0
        local history_paths=
        IFS=: read -r -a history_paths <<<"$BASH_CD_HISTORY"
        for path in "${history_paths[@]}"; do
            echo "$index - $path"
            index=$(($index + 1))
        done
    }

    __cd_jump() {
        local history_len=$(echo $BASH_CD_HISTORY | awk -F: '{print NF}')
        local jump_index="$1"

        if [[ $jump_index -eq 0 ]] && [[ $history_len -eq 0 ]]; then
            echo '0' "$BASH_CD_PREV"
        elif [[ $jump_index -ge $history_len ]]; then
            echo '1' 'Invalid index.'
        else
            local history_paths=
            IFS=: read -r -a history_paths <<<"$BASH_CD_HISTORY"

            echo '0' "${history_paths[$_flag_index]}"
        fi
    }

    # ----------------------------------- MAIN -----------------------------------
    # Variables for CD script
    cd_destination=
    _flag_help=false
    _flag_index=
    _flag_list=false
    argument_count=0

    while [[ $# -gt 0 ]]; do
        case $1 in
        -)
            cd_destination=$BASH_CD_PREV
            argument_count=$(($argument_count + 1))
            ;;
        -h | --help)
            _flag_help=true
            argument_count=$(($argument_count + 1))
            ;;
        -l | --list)
            _flag_list=true
            argument_count=$(($argument_count + 1))
            ;;
        -i | --index)
            _flag_index="$2"
            argument_count=$(($argument_count + 1))
            shift
            ;;
        -i* | --index=* | -*)
            _flag_index=${1##*[-=i]} # remove everything until the last char '-' or '=' or 'i'
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
        __cd_print_history
        return 0
    fi

    if [[ -n "$_flag_index" ]]; then
        if ! __cd_number_check $_flag_index; then
            echo "cd: Index must be a number: $_flag_index"
            return 2
        fi

        read -r jump_status jump_data < <(__cd_jump $_flag_index)
        if [[ $jump_status -ne 0 ]]; then
            echo "cd: $jump_data"
            return 3
        fi

        cd_destination=$jump_data
    fi

    if [[ -z "$cd_destination" ]]; then
        cd_destination=$HOME
    fi

    local current_dir=$(pwd)
    if [[ "$current_dir" = "$cd_destination" ]]; then
        return 0
    fi

    cd_destination=$(realpath -qs $cd_destination)
    if [[ -n "$_flag_index" ]]; then
        echo "cd $cd_destination"
    fi

    builtin cd -- $cd_destination
    local cd_status=$?

    __cd_remove_history $cd_destination

    if [[ $cd_status -eq 0 ]]; then
        BASH_CD_PREV=$current_dir
        __cd_update_history $current_dir
    fi

    return $cd_status
}
