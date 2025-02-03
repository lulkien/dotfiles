bash_git_prompt() {
    # Pre check
    local bare_repo=
    local git_dir=
    local work_tree=
    read -r -d' ' bare_repo git_dir work_tree < \
        <(git rev-parse --is-bare-repository --is-inside-git-dir --is-inside-work-tree 2>/dev/null)

    if [[ -z "$bare_repo" ]] || [[ -z "$git_dir" ]] || [[ -z "$work_tree" ]]; then
        return
    fi

    if $bare_repo && $git_dir; then
        echo -e '\e[0;33mGIT_BARE\e[00m'
        return
    fi

    if $git_dir; then
        echo -e '\e[0;33mGIT_DIR\e[00m'
        return
    fi

    if ! $work_tree; then
        return
    fi

    # Main process
    local branch_name=
    local detached=false
    local dirty=false
    local untrack=false
    local git_string=

    # Fetch branch
    branch_name=$(git branch 2>/dev/null | grep -E '^\*.*$' | sed 's#^\* \(.*\)$#\1#')
    if [[ -z "$branch_name" ]]; then
        return
    fi

    if [[ "$branch_name" =~ ^\(HEAD\ detached\ at\ (.*)\)$ ]]; then
        branch_name=${BASH_REMATCH[1]}
        detached=true
    fi

    if $detached; then
        git_string="\e[0;33m \e[0;91m${branch_name}"
    else
        git_string="\e[0;33m \e[0;35m${branch_name}"
    fi

    # Fetch relative head count
    if [[ "$KBC_SHOW_GIT_RELATIVE" =~ ^(true|yes|ok|1)$ ]]; then
        local ahead=
        local behind=
        read -r behind ahead < <(git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)
        if [[ -n "$behind" ]] && [[ -n "$ahead" ]]; then
            if [[ $ahead -ne 0 ]] && [[ $behind -ne 0 ]]; then
                git_string="${git_string} \e[0;33m"
            elif [[ $ahead -ne 0 ]]; then
                git_string="${git_string} \e[0;32m ${ahead}"
            elif [[ $behind -ne 0 ]]; then
                git_string="${git_string} \e[0;34m ${behind}"
            fi
        fi
    fi

    # Fetch status
    if [[ "$KBC_SHOW_GIT_STATUS" =~ ^(true|yes|ok|1)$ ]]; then
        for stt in $(git status --short | awk '{print $1}' | uniq); do
            if [[ "$stt" =~ [ACDMR] ]]; then
                dirty=true
            elif [[ "$stt" = '??' ]]; then
                untrack=true
            fi
        done

        git_string="${git_string}\e[00m >"
        if ! $dirty && ! $untrack; then
            git_string="${git_string} \e[0;32m"
        fi

        if $dirty; then
            git_string="${git_string} \e[0;33m"
        fi

        if $untrack; then
            git_string="${git_string} \e[0;34m"
        fi
    fi

    # Result
    echo -e "$git_string\e[00m"
}
