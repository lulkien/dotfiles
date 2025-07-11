bash_prompt() {
    KBC_USER='\e[0;36m  \u'
    if [[ $(whoami) = 'root' ]]; then
        KBC_USER='\e[0;31m  \u'
    fi

    if [[ "$KBC_SHOW_HOSTNAME" =~ ^(true|yes|ok|1)$ ]]; then
        declare -p SSH_TTY &>/dev/null &&
            KBC_HOST_ICO='' ||
            KBC_HOST_ICO='󰍹'

        if [[ -n "$KBC_OVERRIDE_HOSTNAME" ]]; then
            KBC_HOSTNAME='\e[0;33m '$KBC_HOST_ICO' '$KBC_OVERRIDE_HOSTNAME
        else
            KBC_HOSTNAME='\e[0;33m '$KBC_HOST_ICO' '$HOSTNAME
        fi
    fi

    echo ${KBC_USER}${KBC_HOSTNAME}' \e[0;34m󰉋 `cwd`\e[00m `bash_git_prompt`\n  '
}
