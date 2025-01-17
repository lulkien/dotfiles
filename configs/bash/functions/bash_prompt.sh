function bash_prompt() {
    declare -p SSH_TTY &>/dev/null && KBC_SESSION='\e[31m \e[00m' || KBC_SESSION=''

    if [[ "$KBC_SHOW_HOSTNAME" =~ ^(true|yes|ok|1)$ ]]; then
        if [[ -n "$KBC_OVERRIDE_HOSTNAME" ]]; then
            KBC_HOSTNAME='\e[0;33m 󰍹 '$KBC_OVERRIDE_HOSTNAME
        else
            KBC_HOSTNAME='\e[0;33m 󰍹 '$(hostname)
        fi
    fi

    echo $KBC_SESSION'\e[0;36m  \u'$KBC_HOSTNAME' \e[0;34m󰉋 `cwd`\e[00m `bash_git_prompt`\n  '
}
