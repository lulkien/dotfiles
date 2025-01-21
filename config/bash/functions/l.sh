unalias l &>/dev/null

l() {
    command ls --color=always --human-readable -l "$@"
}
