bash_prepend_path() {
    [ -z "$1" ] && return
    [ -d "$1" ] || return
    [[ $PATH =~ "$1" ]] && return

    export PATH="$1:$PATH"
}

bash_prepend_path $HOME/.local/bin
bash_prepend_path $HOME/.cargo/bin
bash_prepend_path /home/linuxbrew/.linuxbrew/bin
