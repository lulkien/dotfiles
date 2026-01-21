function cd() {
    # Global variables for this SHELL session
    declare -p KBC_CD_PREV &>/dev/null || declare -g KBC_CD_PREV="$HOME"
    declare -p KBC_CD_HISTORY_LEN &>/dev/null || declare -g -i KBC_CD_HISTORY_LEN=15
    declare -p KBC_CD_HISTORY_FILE &>/dev/null || declare -g KBC_CD_HISTORY_FILE="$HOME/.cd_history"

    # --- Helpers ---
    __cd_atomic_write() {
        local tmp_file
        tmp_file=$(mktemp "${1}.XXXXXX") || return 1
        if cat >"$tmp_file"; then
            [[ -f "$1" ]] && chmod --reference="$1" "$tmp_file" 2>/dev/null
            mv -f "$tmp_file" "$1"
        else
            rm -f "$tmp_file"
            return 1
        fi
    }

    __cd_update_history() {
        [[ -z "$1" || "$1" = "$HOME" ]] && return
        {
            echo "$1"
            [[ -f "$KBC_CD_HISTORY_FILE" ]] && cat "$KBC_CD_HISTORY_FILE"
        } |
            awk '!seen[$0]++' | head -n "$KBC_CD_HISTORY_LEN" | __cd_atomic_write "$KBC_CD_HISTORY_FILE"
    }

    __cd_remove_history() {
        [[ -z "$1" || ! -f "$KBC_CD_HISTORY_FILE" ]] && return
        awk -v line="$1" '$0 != line' "$KBC_CD_HISTORY_FILE" | __cd_atomic_write "$KBC_CD_HISTORY_FILE"
    }

    # ----------------------------------- MAIN -----------------------------------
    local cl_red='\e[1;31m'
    local cl_yellow='\e[1;33m'
    local cl_reset='\e[0m'

    local flag_list=false
    local opt=
    OPTIND=1 # Required: reset getopts index for function calls

    while getopts "hl" opt; do
        case "$opt" in
        h)
            echo "Usage: cd [-l] [path]"
            return 0
            ;;
        l) flag_list=true ;;
        *) return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    local dest="$1"
    local current_dir=$(pwd)

    if $flag_list; then
        if [[ ! -s "$KBC_CD_HISTORY_FILE" ]]; then
            echo -e "${cl_red}cd${cl_reset}: History empty."
            return 1
        fi

        # Load history into array
        local -a hist=()
        while IFS= read -r line; do hist+=("$line"); done <"$KBC_CD_HISTORY_FILE"

        echo "Select a directory:"
        COLUMNS=1 # Force vertical list
        select choice in "${hist[@]}"; do
            [[ -n "$choice" ]] && dest="$choice" && break
            echo "Invalid selection." >&2 && return 2
        done
        echo "----------------------------"
        echo -e "${cl_yellow}cd${cl_reset}: $dest"
    fi

    # Path logic
    if [[ -z "$dest" ]]; then
        dest="$HOME"
    elif [[ "$dest" == "-" ]]; then
        dest="$KBC_CD_PREV"
        echo -e "${cl_yellow}cd${cl_reset}: $dest"
    else
        # Resolve path to absolute for clean history
        local real_p
        real_p=$(realpath -q "$dest")
        [[ $? -eq 0 ]] && dest="$real_p"
    fi

    [[ "$current_dir" == "$dest" ]] && return 0

    # REMOVE HISTORY NO MATTER WHAT
    # BECAUSE OF THAT HISTORY MAY NOT EXIST ANYMORE
    __cd_remove_history "$dest"

    builtin cd -- "$dest"
    local status=$?

    [[ $status -ne 0 ]] && return $status

    KBC_CD_PREV="$current_dir"
    __cd_update_history "$dest"

    return 0
}

