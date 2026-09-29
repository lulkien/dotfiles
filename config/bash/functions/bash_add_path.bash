# ------------------------------------------------------------------
# Helpers are file scope on purpose: a function defined inside another one is
# redefined as a global on every call and can collide with other helpers.
_bash_add_path_usage() {
    cat <<-'EOF'
	Usage: bash_add_path [OPTIONS] PATH...

	Add directories to PATH, resolving symlinks and skipping entries that are
	already there and paths that do not exist.

	  -a, --append     Append to the end of PATH (default: prepend).
	  -n, --dry-run    Print the resulting export instead of applying it.
	  -v, --verbose    Report each decision on stderr.
	  -h, --help       Show this message.
	EOF
}

# The verbose flag is passed in so the helper stays stateless.
_bash_add_path_log() {
    [[ $1 == true ]] || return 0
    shift
    printf 'bash_add_path: %s\n' "$*" 1>&2
}

# Textual cleanup only: ~ expansion and one trailing slash.
_bash_add_path_canon() {
    local p=$1
    [[ $p == '~' || $p == '~/'* ]] && p=$HOME${p:1}
    [[ $p == / ]] || p=${p%/}
    printf '%s' "$p"
}

bash_add_path() {
    local dry_run=false
    local append_mode=false
    local verbose=false
    local -a paths=()

    while (($#)); do
        case $1 in
        -a | --append)
            append_mode=true
            shift
            ;;
        -n | --dry-run)
            dry_run=true
            shift
            ;;
        -v | --verbose)
            verbose=true
            shift
            ;;
        -h | --help)
            _bash_add_path_usage
            return 0
            ;;
        --)
            shift
            paths+=("$@")
            break
            ;;
        -*)
            printf 'bash_add_path: unknown option: %s\n' "$1" 1>&2
            _bash_add_path_usage 1>&2
            return 1
            ;;
        *)
            paths+=("$1")
            shift
            ;;
        esac
    done

    if ((${#paths[@]} == 0)); then
        printf 'bash_add_path: no paths provided\n' 1>&2
        _bash_add_path_usage 1>&2
        return 1
    fi

    # Existing entries are kept exactly as written; their canonical and resolved
    # forms are only used to tell whether a new path is already in PATH.
    local -a existing=()
    local -A seen=()
    local entry key resolved
    local -a raw=()
    IFS=: read -ra raw <<< "$PATH"
    for entry in "${raw[@]}"; do
        existing+=("$entry")
        # An empty component means the cwd; it has no key to remember, and bash
        # rejects an empty subscript on an associative array.
        [[ -n $entry ]] || continue
        key=$(_bash_add_path_canon "$entry")
        seen[$key]=1
        if [[ $key == /* ]]; then
            resolved=$(realpath -e -- "$key" 2>/dev/null) && seen[$resolved]=1
        fi
    done

    local -a new_paths=()
    local path abs
    for path in "${paths[@]}"; do
        [[ -n $path ]] || continue
        key=$(_bash_add_path_canon "$path")
        abs=$(realpath -e -- "$key" 2>/dev/null) || {
            _bash_add_path_log "$verbose" "does not exist: '$path'"
            continue
        }
        if [[ ! -d $abs ]]; then
            _bash_add_path_log "$verbose" "not a directory: '$abs'"
            continue
        fi
        if [[ -n ${seen[$abs]+_} ]]; then
            _bash_add_path_log "$verbose" "already in PATH: '$abs'"
            continue
        fi
        seen[$abs]=1
        new_paths+=("$abs")
    done

    if ((${#new_paths[@]} == 0)); then
        _bash_add_path_log "$verbose" "nothing to add"
        return 1
    fi

    local -a ordered=()
    if $append_mode; then
        ordered=("${existing[@]}" "${new_paths[@]}")
    else
        ordered=("${new_paths[@]}" "${existing[@]}")
    fi

    local new_path
    printf -v new_path '%s:' "${ordered[@]}"
    new_path=${new_path%:}

    if $dry_run; then
        printf 'export PATH=%s\n' "$(printf '%q' "$new_path")"
        return 0
    fi

    export PATH="$new_path"
    _bash_add_path_log "$verbose" "added ${#new_paths[@]} path(s)"
    return 0
}
