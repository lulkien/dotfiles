function cd() {
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

    __cd_prepend_history() {
        [[ -z "$1" ]] && return

        [[ -z "$BASH_CD_HISTORY" ]] &&            # Condition
            BASH_CD_HISTORY="$1" ||               # Do if true
            BASH_CD_HISTORY="$1:$BASH_CD_HISTORY" # Do if false
    }

    __cd_append_history() {
        [[ -z "$1" ]] && return

        [[ -z "$BASH_CD_HISTORY" ]] &&            # Condition
            BASH_CD_HISTORY="$1" ||               # Do if true
            BASH_CD_HISTORY="$BASH_CD_HISTORY:$1" # Do if false
    }

    __cd_update_history() {
        [[ -z "$1" || "$1" = "$HOME" ]] && return
        __cd_prepend_history "$1"
    }

    __cd_remove_history() {
        [[ -z "$1" || "$1" = "$HOME" ]] && return

        # Save tmp history
        local tmp_history=
        IFS=: read -r -a tmp_history <<<"$BASH_CD_HISTORY"

        # Clean history
        BASH_CD_HISTORY=
        local history_len=0

        # Update history
        for item in "${tmp_history[@]}"; do
            [[ $item = $1 ]] && continue

            history_len=$(($history_len + 1))
            [[ $history_len -ge $BASH_CD_HISTORY_LEN ]] && break # Overflow

            __cd_append_history "$item"
        done
    }

    __cd_print_history() {
        local index=0
        local tmp_history=

        IFS=: read -r -a tmp_history <<<"$BASH_CD_HISTORY"

        for item in "${tmp_history[@]}"; do
            echo "$index - $item"
            index=$(($index + 1))
        done
    }

    __cd_jump() {
        local jump_index="$1"
        local history_len=$(echo $BASH_CD_HISTORY | awk -F: '{print NF}')

        if [[ $jump_index -eq 0 ]] && [[ $history_len -eq 0 ]]; then
            echo "$BASH_CD_PREV"
            return 0
        fi

        if [[ $jump_index -ge $history_len ]]; then
            echo 'Invalid index.'
            return 1
        fi

        local tmp_history=
        IFS=: read -r -a tmp_history <<<"$BASH_CD_HISTORY"

        echo "${tmp_history[$_flag_index]}"
        return 0
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
        echo "cd: Too many arguments. $argument_count"
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

        local jump_data=
        local jump_code=

        jump_data=$(__cd_jump $_flag_index)
        jump_code=$?

        if [[ $jump_code -ne 0 ]]; then
            echo "cd: $jump_data"
            return 3
        fi

        cd_destination=$jump_data
    fi

    [[ -z "$cd_destination" ]] && cd_destination=$HOME

    local current_dir=$(pwd)
    [[ "$current_dir" = "$cd_destination" ]] && return 0

    cd_destination=$(realpath -q $cd_destination)
    [[ -n "$_flag_index" ]] && echo "cd $cd_destination"

    builtin cd -- $cd_destination
    local cd_status=$?

    __cd_remove_history $cd_destination

    if [[ $cd_status -eq 0 ]]; then
        BASH_CD_PREV=$current_dir
        __cd_update_history $current_dir
    fi

    return $cd_status
}
