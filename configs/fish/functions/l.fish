function l --wraps=ls --description 'Implementation for command l'
    set -l OS_TYPE (uname -s)
    if string match -q Linux "$OS_TYPE"
        command ls -lh --ignore=lost+found --color=always $argv
    else if string match -q Darwin "$OS_TYPE"
        command ls -lhG $argv
    else
        command ls -l $argv
    end
end
