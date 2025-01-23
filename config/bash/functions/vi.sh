vi() {
    if command -v vim &>/dev/null; then
        command vim "$@"
    else
        command vi "$@"
    fi
}
