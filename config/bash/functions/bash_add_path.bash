bash_add_path() {
    local dry_run=false
    local append_mode=false
    local verbose=false

    # Parse arguments
    local paths=()
    while [[ $# -gt 0 ]]; do
        case $1 in
        '-a' | '--append')
            append_mode=true
            shift
            ;;
        '-n' | '--dry-run')
            dry_run=true
            shift
            ;;
        '-v' | '--verbose')
            verbose=true
            shift
            ;;
        '-h' | '--help')
            echo "Usage: bash_add_path [OPTIONS] PATH..."
            echo "Options:"
            echo "  -a, --append     Append new path to the end of current PATH."
            echo "  -n, --dry-run    Show what would be done without doing it."
            echo "  -h, --help       Show this help message."
            return 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            return 1
            ;;
        *)
            paths+=("$1")
            shift
            ;;
        esac
    done

    # Get current PATH
    local current_path="$PATH"

    # Process each path
    local newpaths=()

    for path in "${paths[@]}"; do
        # Canonicalize path (resolve symlinks, get absolute path)
        local p=$(realpath -- "$path" 2>/dev/null || echo "")

        # Ignore non-existing paths
        if [[ ! -d "$p" ]]; then
            if $verbose; then
                echo "Skipping non-existent path: $path" >&2
            fi
            continue
        fi

        # Check if path already exists in PATH
        local found=false
        local IFS=':'
        for existing_path in $current_path; do
            if [[ "$existing_path" = "$p" ]]; then
                found=true
                break
            fi
        done
        unset IFS

        # Check if path already in newpaths
        local duplicated=false
        for newp in "${newpaths[@]}"; do
            if [[ "$newp" = "$p" ]]; then
                duplicated=true
                break
            fi
        done

        if ! $found && ! $duplicated; then
            newpaths+=("$p")
        fi
    done

    # If no paths to add, return
    if [[ ${#newpaths[@]} -eq 0 ]]; then
        return 1
    fi

    # Prepend new paths to PATH
    local new_paths_str=$(
        IFS=':'
        echo "${newpaths[*]}"
    )

    local new_path=
    if $append_mode; then
        new_path="$current_path:$new_paths_str"
    else
        new_path="$new_paths_str:$current_path"
    fi

    if $dry_run; then
        echo "export PATH=\"$new_path\""
    else
        export PATH="$new_path"
    fi

    return 0
}

