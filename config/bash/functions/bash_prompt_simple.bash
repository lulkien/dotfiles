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

    echo '\e[0;32m\u\e[00m@\e[0;33m\h \e[0;34m\w \e[31m`git_prompt_simple`\e[00m\$ '
}
