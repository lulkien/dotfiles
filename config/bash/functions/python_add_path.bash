# ------------------------------------------------------------------
# Helpers are file scope on purpose: a function defined inside another one is
# redefined as a global on every call and can collide with other helpers.
_python_add_path_usage() {
    cat <<-'EOF'
	Usage: python_add_path [OPTIONS] PATH...

	Add the site-packages directories found under each PATH to PYTHONPATH.
	Passing a site-packages directory directly works too.

	  -a, --append     Append to the end of PYTHONPATH (default: prepend).
	  -n, --dry-run    Print the resulting export instead of applying it.
	  -v, --verbose    Report each decision on stderr.
	  -h, --help       Show this message.
	EOF
}

# The verbose flag is passed in so the helper stays stateless.
_python_add_path_log() {
    [[ $1 == true ]] || return 0
    shift
    printf 'python_add_path: %s\n' "$*" 1>&2
}

# Textual cleanup only: ~ expansion and one trailing slash.
_python_add_path_canon() {
    local p=$1
    [[ $p == '~' || $p == '~/'* ]] && p=$HOME${p:1}
    [[ $p == / ]] || p=${p%/}
    printf '%s' "$p"
}

python_add_path() {
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
            _python_add_path_usage
            return 0
            ;;
        --)
            shift
            paths+=("$@")
            break
            ;;
        -*)
            printf 'python_add_path: unknown option: %s\n' "$1" 1>&2
            _python_add_path_usage 1>&2
            return 1
            ;;
        *)
            paths+=("$1")
            shift
            ;;
        esac
    done

    if ((${#paths[@]} == 0)); then
        printf 'python_add_path: no paths provided\n' 1>&2
        _python_add_path_usage 1>&2
        return 1
    fi

    # Existing entries are kept exactly as written (a symlinked venv may be
    # deliberate); their canonical and resolved forms key the dedupe.
    local -a existing=()
    local -A seen=()
    local entry key resolved
    local -a raw=()
    IFS=: read -ra raw <<< "${PYTHONPATH:-}"
    for entry in "${raw[@]}"; do
        [[ -n $entry ]] || continue
        key=$(_python_add_path_canon "$entry")
        resolved=$(realpath -e -- "$key" 2>/dev/null) || resolved=$key
        if [[ -n ${seen[$resolved]+_} ]]; then
            _python_add_path_log "$verbose" "dropping duplicate PYTHONPATH entry: '$entry'"
            continue
        fi
        seen[$resolved]=1
        existing+=("$entry")
    done

    local -a new_entries=()
    local added=0
    local skipped=0
    local path abs site
    local -a found=()
    for path in "${paths[@]}"; do
        if [[ -z $path ]]; then
            ((++skipped))
            continue
        fi

        abs=$(realpath -e -- "$(_python_add_path_canon "$path")" 2>/dev/null) || {
            _python_add_path_log "$verbose" "does not exist or not reachable: '$path'"
            ((++skipped))
            continue
        }
        if [[ ! -d $abs ]]; then
            _python_add_path_log "$verbose" "not a directory: '$abs'"
            ((++skipped))
            continue
        fi

        found=()
        if [[ ${abs##*/} == site-packages ]]; then
            # Pointed straight at one, no need to look around.
            found=("$abs")
        else
            # Prune the directories that never hold a usable site-packages but
            # cost the most to walk.
            while IFS= read -r -d '' site; do
                found+=("$site")
            done < <(find "$abs" \
                \( -name .git -o -name node_modules -o -name __pycache__ \) -prune -o \
                -type d -name site-packages -print0 | sort -z)
        fi

        if ((${#found[@]} == 0)); then
            _python_add_path_log "$verbose" "no site-packages found under '$abs'"
            ((++skipped))
            continue
        fi

        for site in "${found[@]}"; do
            resolved=$(realpath -e -- "$site" 2>/dev/null) || resolved=$site
            if [[ -n ${seen[$resolved]+_} ]]; then
                _python_add_path_log "$verbose" "duplicate, skipping '$resolved'"
                ((++skipped))
                continue
            fi
            seen[$resolved]=1
            new_entries+=("$resolved")
            ((++added))
            _python_add_path_log "$verbose" "found '$resolved'"
        done
    done

    if ((added == 0)); then
        _python_add_path_log "$verbose" "nothing new to add (added=0, skipped=$skipped)"
        return 1
    fi

    local -a ordered=()
    if $append_mode; then
        ordered=("${existing[@]}" "${new_entries[@]}")
    else
        ordered=("${new_entries[@]}" "${existing[@]}")
    fi

    # One interpreter cannot use site-packages from two different versions.
    local -A versions=()
    local version v
    for entry in "${ordered[@]}"; do
        [[ $entry =~ /python([0-9]+\.[0-9]+)/ ]] && versions[${BASH_REMATCH[1]}]=1
    done
    if ((${#versions[@]} > 1)); then
        version=
        for v in $(printf '%s\n' "${!versions[@]}" | sort); do
            version+="${version:+, }$v"
        done
        printf 'python_add_path: warning: PYTHONPATH now mixes python %s\n' "$version" 1>&2
    fi

    local new_pythonpath
    printf -v new_pythonpath '%s:' "${ordered[@]}"
    new_pythonpath=${new_pythonpath%:}

    if $dry_run; then
        printf 'python_add_path: [dry-run] added=%d skipped=%d\n' "$added" "$skipped"
        printf 'export PYTHONPATH=%s\n' "$(printf '%q' "$new_pythonpath")"
        return 0
    fi

    export PYTHONPATH="$new_pythonpath"
    _python_add_path_log "$verbose" "done, added=$added skipped=$skipped"
    return 0
}
