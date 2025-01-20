function ls() {
    command ls --color=always "$@"
}

function l() {
    command ls --color=always --human-readable -l "$@"
}

function ll() {
    command ls --color=always --almost-all --human-readable -l "$@"
}
