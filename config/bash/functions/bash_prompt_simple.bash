function git_prompt_simple() {
    if [[ "$KBC_GIT_DISABLED" =~ ^(true|yes|ok|1)$ ]]; then
        return
    fi

    if [[ -z "$(command -v git)" ]]; then
        export KBC_GIT_DISABLE=1
        return
    fi

    git_branch=$(git branch --show-current 2>/dev/null)

    if [[ -n "${git_branch}" ]]; then
        echo "(${git_branch}) "
    fi
}

function bash_prompt_simple() {

    echo '\[\033[0;32m\]\u\[\033[00m\]@\[\033[0;33m\]\h \[\033[0;34m\]\w \[\033[31m\]`git_prompt_simple`\[\033[00m\]\$ '
}
