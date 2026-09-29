# ------------------------------------------------------------------
# In-memory maps
#
#   KBC_ABBR_MAP        key -> expansion
#   KBC_ABBR_POSITIONS  key -> command (default) | anywhere
#
unset KBC_ABBR_MAP KBC_ABBR_POSITIONS
declare -A KBC_ABBR_MAP
declare -A KBC_ABBR_POSITIONS

# Position of an abbreviation added without --position.
KBC_ABBR_POSITION_DEFAULT=command

# Characters that put the word after them in command position, plus the
# blanks that separate words: anything a command word may follow.
KBC_ABBR_SEPARATORS=';|&({!'
KBC_ABBR_BOUNDARY="[[:space:]${KBC_ABBR_SEPARATORS}]"

# ------------------------------------------------------------------
# Usage
_abbr_usage() {
    cat 1>&2 <<-'EOF'
	Usage: abbr <-a [-p POSITION] KEY VALUE... | -e KEY | -s KEY | -l> [-v]

	  -a, --add KEY VALUE...  add or replace an abbreviation
	  -p, --position POS      where it expands: command (default) or anywhere
	  -e, --erase KEY         remove an abbreviation
	  -s, --show KEY          print the expansion of KEY
	  -l, --list              list abbreviations
	  -v, --verbose           report what changed
	  -h, --help              show this message

	command:  only where a command can start, i.e. at the start of the line
	          or after a separator such as ; | && (
	anywhere: as any word, for abbreviations that are arguments, e.g.
	          abbr -a -p anywhere L '| less'
	EOF
}

# ------------------------------------------------------------------
# Main command: abbr
function abbr() {
    local verbose=false
    local action=
    local key=
    local position=

    local parsed
    parsed="$(getopt -o vhlae:s:p: -l verbose,help,list,add,erase:,show:,position: -n abbr -- "$@")" || {
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
        -p | --position)
            position=$2
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

    # --add takes its key positionally instead of as an option argument, so
    # --position may sit anywhere: abbr -a -p anywhere L '| less'
    if [[ $action == add && -z $key && $# -gt 0 ]]; then
        key=$1
        shift
    fi

    if [[ -n $position && $position != "$KBC_ABBR_POSITION_DEFAULT" && $position != anywhere ]]; then
        echo "abbr: --position must be $KBC_ABBR_POSITION_DEFAULT or anywhere." 1>&2
        return 1
    fi
    if [[ -n $position && $action != add ]]; then
        echo "abbr: --position only applies to --add." 1>&2
        return 1
    fi

    case "$action" in
    list)
        printf '%-20s %-9s %s\n' "Key" "Position" "Expansion"
        printf '%-20s %-9s %s\n' "----" "--------" "----------"
        for k in "${!KBC_ABBR_MAP[@]}"; do
            printf '%-20s %-9s %s\n' "$k" "${KBC_ABBR_POSITIONS[$k]:-$KBC_ABBR_POSITION_DEFAULT}" "${KBC_ABBR_MAP[$k]}"
        done | sort
        ;;
    add)
        if [[ -z $key || $# -eq 0 ]]; then
            echo "abbr: --add requires a key and a value." 1>&2
            return 1
        fi
        KBC_ABBR_MAP["$key"]="$*"
        KBC_ABBR_POSITIONS["$key"]=${position:-$KBC_ABBR_POSITION_DEFAULT}
        if [[ $verbose == true ]]; then
            echo "Modified abbreviation: $key → $* (${KBC_ABBR_POSITIONS[$key]})"
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
        unset "KBC_ABBR_MAP[$key]" "KBC_ABBR_POSITIONS[$key]"
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

# Expand the abbreviation that ends at the cursor, if its position allows it
# (command position by default, anywhere for keys added with --position
# anywhere). Returns 0 when it expanded something. The word must end exactly at
# the cursor, which is what makes Ctrl-Space work as an escape hatch: it leaves
# the cursor after a space, so there is no word to expand.
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

    # `anywhere` abbreviations expand as any word. The rest only expand where
    # a command can start, so `pls` and `cd /tmp && pls` match, but `git pls`
    # (an argument) does not.
    if [[ ${KBC_ABBR_POSITIONS[$token]:-$KBC_ABBR_POSITION_DEFAULT} != anywhere ]]; then
        local prev=${head:0:cut}
        prev=${prev%"${prev##*[![:space:]]}"}
        if [[ -n $prev && "${prev: -1}" != [$KBC_ABBR_SEPARATORS] ]]; then
            return 1
        fi
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
