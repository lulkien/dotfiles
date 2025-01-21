unalias ls &>/dev/null

ls() {
    command ls --color=always "$@"
}
