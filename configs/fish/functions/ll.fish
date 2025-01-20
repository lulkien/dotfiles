function ll --wraps=ls --description 'Implementation for command l'
    set -l OS_TYPE (uname -s)
    if string match -q Linux "$OS_TYPE"
        command ls --ignore=lost+found --color=always --almost-all --human-readable -l $argv
    else if string match -q Darwin "$OS_TYPE"
        command ls -lhG $argv
    else
        command ls -l $argv
    end
end
