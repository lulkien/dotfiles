do_command() {
    echo -e "\e[1;33mProcess: \e[00m$@"
    echo "----------------------------------------"
    eval "$@"
}
