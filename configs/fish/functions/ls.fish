function ls --description 'Custom implementation for command ls'
    set -l OS_TYPE (uname -s)
    if string match -q Linux "$OS_TYPE"
        command ls --ignore=lost+found --color=always $argv
    else if string match -q Darwin "$OS_TYPE"
        command ls -G $argv
    else
        command ls $argv
    end
end
