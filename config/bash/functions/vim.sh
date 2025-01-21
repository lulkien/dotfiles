vim() {
    if command -v nvim &>/dev/null; then
        nvim "$@"
    elif command -v vim &>/dev/null; then
        vim "$@"
    else
        vi "$@"
    fi
}
