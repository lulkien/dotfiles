function bash_prompt() {
    declare -p SSH_TTY &>/dev/null && KBC_SESSION='\e[31m \e[00m' || KBC_SESSION=''
    echo $KBC_SESSION'\e[1;36m  \u \e[1;34m󰉋 `cwd`\e[00m `bash_git_prompt`\n  '
}
