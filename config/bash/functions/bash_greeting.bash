bash_greeting() {
    if [[ -n "$KBC_BASH_GREETING" ]]; then
        echo -e "$KBC_BASH_GREETING"
    fi
}

