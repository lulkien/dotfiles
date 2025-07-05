alias rl=bash_reload

alias pls=sudo
alias please=sudo

alias rf='rm -rf'

alias ..='cd ..'
alias ...='cd ../..'

if command -v zellij &>/dev/null; then
    alias zn="zellij"
    alias zl="zellij list-sessions"
    alias za="zellij attach"
    alias zk="zellij kill-session"
    alias zka="zellij kill-all-sessions"
    alias zd="zellij delete-session"
    alias zda="zellij delete-all-sessions"
fi
