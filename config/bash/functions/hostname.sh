function hostname() {
    if [[ -n "$HOSTNAME" ]]; then
        printf "${HOSTNAME}\n"
    elif command -v hostname &>/dev/null; then
        command hostname
    else
        local HOSTNAME_=$(head -1 /etc/hostname)
        [[ -n "$HOSTNAME_" ]] && printf "${HOSTNAME_}\n" || printf "Unknown\n"
    fi

}
