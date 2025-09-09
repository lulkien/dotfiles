function kfc_fish_prompt_simple
    if test "$USER" = root
        set -f user_string $KFC_RED_N$USER
        set -f cmd_start $KFC_RESET'#'
    else
        set -f user_string $KFC_GREEN_N$USER
        set -f cmd_start $KFC_RESET'$ '
    end

    set -f host_string $KFC_YELLOW_N$hostname

    set -f cwd_string $KFC_BLUE_N(prompt_pwd --full-length-dirs=0 --dir-length=0)

    printf $user_string$KFC_RESET'@'$host_string' '$cwd_string' '$cmd_start
end
