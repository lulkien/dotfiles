# ------------------------------------------------------------------
# In‑memory map
unset KBC_ABBR_MAP
declare -A KBC_ABBR_MAP

# ------------------------------------------------------------------
# Main command: abbr
function abbr() {
    function _usage() {
        echo "Usage: abbr [-v|--verbose] [-a|--add key value] [-e|--erase key] [-l|--list]" 1>&2
        return 1
    }

    local opts="$(getopt -o vla:e: -l verbose,list,add:,erase: -n abbr -- "$@")"

    local verbose=false
    local action=
    local key=
    local value=

    while [[ $# -gt 0 ]]; do
        case "$1" in
        -v | --verbose)
            verbose=true
            shift
            ;;
        -l | --list)
            action=list
            shift
            break
            ;;
        -a | --add)
            action=add
            key=$2
            value=$3
            shift 3
            break
            ;;
        -e | --erase)
            action=erase
            key=$2
            shift 2
            break
            ;;
        *) break ;;
        esac
    done

    case "$action" in
    list)
        printf '%-20s %s\n' "Key" "Expansion"
        printf '%-20s %s\n' "----" "----------"
        for k in "${!KBC_ABBR_MAP[@]}"; do
            printf '%-20s %s\n' "$k" "${KBC_ABBR_MAP[$k]}"
        done | sort
        return 0
        ;;
    add)
        if [[ -z $key || -z $value ]]; then
            echo "Add requires a key and a value." 1>&2
            return 1
        fi
        KBC_ABBR_MAP["$key"]="$value"
        $verbose && echo "Modified abbreviation: $key → $value"
        ;;
    erase)
        if [[ -z $key ]]; then
            echo "Erase requires a key." 1>&2
            return 1
        fi
        if [[ -z "${KBC_ABBR_MAP[$key]}" ]]; then
            echo "Key \"$key\" not found." 1>&2
            return 1
        fi
        unset "KBC_ABBR_MAP[$key]"
        $verbose && echo "Deleted abbreviation: $key"
        ;;
    "")
        echo "No action specified." 1>&2
        _usage
        return 1
        ;;
    esac
}

# ------------------------------------------------------------------
# Interactive expansion
_expand_abbreviation() {
    local line="${READLINE_LINE}"
    local point=$READLINE_POINT

    # Preserve leading whitespace
    local ws="${line%%[^[:space:]]*}"
    local ws_len=${#ws}
    local rest="${line:ws_len}"

    # Empty line → just insert a space
    if [[ -z "$rest" ]]; then
        READLINE_LINE="${READLINE_LINE:0:$point} ${READLINE_LINE:$point}"
        ((READLINE_POINT++))
        return
    fi

    # First word (up to next whitespace)
    local first_word="${rest%%[[:space:]]*}"

    # Expand only when cursor is exactly after the first word
    if ((point == ws_len + ${#first_word})) && [[ -n "$first_word" && -n "${KBC_ABBR_MAP[$first_word]}" ]]; then
        local expansion="${KBC_ABBR_MAP[$first_word]}"
        READLINE_LINE="${ws}${expansion} ${rest:${#first_word}}"
        READLINE_POINT=$((ws_len + ${#expansion} + 1))
        return
    fi

    # Default: insert a literal space
    READLINE_LINE="${READLINE_LINE:0:$point} ${READLINE_LINE:$point}"
    ((READLINE_POINT++))
}
