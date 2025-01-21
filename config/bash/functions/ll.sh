unalias ll &>/dev/null

ll() {
    command ls --color=always --almost-all --human-readable -l "$@"
}
