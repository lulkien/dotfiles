if command -v apt &>/dev/null; then
    if [ "$(id -u)" -eq 0 ]; then
        SUDO_PREFIX=""
    else
        SUDO_PREFIX="sudo "
    fi

    alias pit='do_command "'${SUDO_PREFIX}'apt install"'
    alias prm='do_command "'${SUDO_PREFIX}'apt purge"'
    alias puf='do_command "'${SUDO_PREFIX}'apt update; '${SUDO_PREFIX}'apt upgrade;"'
    alias pcl='do_command "'${SUDO_PREFIX}'apt autoclean; '${SUDO_PREFIX}'apt autoremove;"'
    alias pss='do_command "apt-cache search"'
fi
