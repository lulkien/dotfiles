# ------------------------------------------------------------------
# In-memory map
unset KBC_ABBR_MAP
declare -A KBC_ABBR_MAP

# Characters that put the word after them in command position, plus the
# blanks that separate words: anything a command word may follow.
KBC_ABBR_SEPARATORS=';|&({!'
KBC_ABBR_BOUNDARY="[[:space:]${KBC_ABBR_SEPARATORS}]"

# ------------------------------------------------------------------
# Usage
_abbr_usage() {
    cat 1>&2 <<-'EOF'
	Usage: abbr <-a KEY VALUE... | -e KEY | -s KEY | -l> [-v]

	  -a, --add KEY VALUE...  add or replace an abbreviation
	  -e, --erase KEY         remove an abbreviation
	  -s, --show KEY          print the expansion of KEY
	  -l, --list              list abbreviations
	  -v, --verbose           report what changed
	  -h, --help              show this message
	EOF
}

# ------------------------------------------------------------------
# Main command: abbr
function abbr() {
    local verbose=false
    local action=
    local key=

    local parsed
    parsed="$(getopt -o vhla:e:s: -l verbose,help,list,add:,erase:,show: -n abbr -- "$@")" || {
        _abbr_usage
        return 1
    }
    eval "set -- $parsed"

    while (($#)); do
        case "$1" in
        -v | --verbose)
            verbose=true
            ;;
        -h | --help)
            _abbr_usage
            return 0
            ;;
        -l | --list)
            action=list
            ;;
        -a | --add)
            action=add
            key=$2
            shift
            ;;
        -e | --erase)
            action=erase
            key=$2
            shift
            ;;
        -s | --show)
            action=show
            key=$2
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
        esac
        shift
    done

    case "$action" in
    list)
        printf '%-20s %s\n' "Key" "Expansion"
        printf '%-20s %s\n' "----" "----------"
        for k in "${!KBC_ABBR_MAP[@]}"; do
            printf '%-20s %s\n' "$k" "${KBC_ABBR_MAP[$k]}"
        done | sort
        ;;
    add)
        if [[ -z $key || $# -eq 0 ]]; then
            echo "abbr: --add requires a key and a value." 1>&2
            return 1
        fi
        KBC_ABBR_MAP["$key"]="$*"
        if [[ $verbose == true ]]; then
            echo "Modified abbreviation: $key → $*"
        fi
        ;;
    erase)
        if [[ -z $key ]]; then
            echo "abbr: --erase requires a key." 1>&2
            return 1
        fi
        if [[ ! -v KBC_ABBR_MAP[$key] ]]; then
            echo "abbr: no such abbreviation: $key" 1>&2
            return 1
        fi
        unset "KBC_ABBR_MAP[$key]"
        if [[ $verbose == true ]]; then
            echo "Deleted abbreviation: $key"
        fi
        ;;
    show)
        if [[ -z $key ]]; then
            echo "abbr: --show requires a key." 1>&2
            return 1
        fi
        if [[ ! -v KBC_ABBR_MAP[$key] ]]; then
            echo "abbr: no such abbreviation: $key" 1>&2
            return 1
        fi
        printf '%s\n' "${KBC_ABBR_MAP[$key]}"
        ;;
    "")
        echo "abbr: no action specified." 1>&2
        _abbr_usage
        return 1
        ;;
    esac
}

# ------------------------------------------------------------------
# Interactive expansion, driven from input.bash
#
# READLINE_POINT is a byte offset, so the whole file works in bytes
# (LC_ALL=C) to keep ${#x} and ${x:offset:length} in the same unit and
# to stay correct for non-ASCII input before the cursor.

# Expand the abbreviation that ends at the cursor, if it sits in command
# position. Returns 0 when it expanded something.
_abbr_expand_at_cursor() {
    local LC_ALL=C
    local line=$READLINE_LINE
    local point=$READLINE_POINT
    local head=${line:0:point}

    # Word under the cursor: everything after the last blank or separator.
    local token=${head##*$KBC_ABBR_BOUNDARY}
    local cut=$((${#head} - ${#token}))

    # Nothing under the cursor, or not an abbreviation
    [[ -n $token ]] || return 1
    [[ -v KBC_ABBR_MAP[$token] ]] || return 1

    # Command position: what precedes the word is blank space, a separator,
    # or nothing -- so `pls` and `cd /tmp && pls` expand, but `git pls` (an
    # argument) does not.
    local prev=${head:0:cut}
    prev=${prev%"${prev##*[![:space:]]}"}
    if [[ -n $prev && "${prev: -1}" != [$KBC_ABBR_SEPARATORS] ]]; then
        return 1
    fi

    local expansion=${KBC_ABBR_MAP[$token]}
    READLINE_LINE="${line:0:cut}${expansion}${line:point}"
    READLINE_POINT=$((cut + ${#expansion}))
    return 0
}

_abbr_insert_space() {
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT} ${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$((READLINE_POINT + 1))
    return 0
}

# Space: expand in command position, then insert the space that was typed.
_abbr_on_space() {
    _abbr_expand_at_cursor
    _abbr_insert_space
}

# Ctrl-Space: literal space, no expansion (escape hatch, like fish).
_abbr_literal_space() {
    _abbr_insert_space
}

# Enter: expand in command position, no space appended. The \C-m macro in
# input.bash runs this before accept-line.
_abbr_before_accept() {
    _abbr_expand_at_cursor
    return 0
}
