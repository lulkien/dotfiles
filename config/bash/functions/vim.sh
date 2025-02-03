vim() {
    if command -v nvim &>/dev/null; then
        command nvim "$@"
    elif command -v vim &>/dev/null; then
        command vim "$@"
    else
        command vi "$@"
    fi
}
