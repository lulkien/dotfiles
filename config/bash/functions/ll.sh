[[ $(type -t ll) = alias ]] && unalias ll

ll() {
    command ls --color=always --almost-all --human-readable -l "$@"
}
