[[ $(type -t ls) = alias ]] && unalias ls

ls() {
    command ls --color=always "$@"
}
