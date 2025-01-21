[[ $(type -t l) = alias ]] && unalias l

l() {
    command ls --color=always --human-readable -l "$@"
}
