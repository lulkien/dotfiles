function fish_prompt --description 'Write out the prompt'
    set prompt_string ''

    set user_string $KFC_CYAN_N' '(whoami)
    if test (whoami) = root
        set user_string $KFC_RED_N' '(whoami)
    end

    set host_string ''
    set cwd_string $KFC_BLUE_N' 󰉋 '(prompt_pwd --full-length-dirs=2 --dir-length=3)
    set git_string (kfc_git_prompt)

    set command_prefix $KFC_CL_NONE'  '

    # Check being remoted via ssh
    if set -q SSH_TTY
        set prompt_string $KFC_RED_N" "
    end

    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_HOSTNAME"
        if test -n "$KFC_OVERRIDE_HOSTNAME"
            set host_string $KFC_YELLOW_N' 󰍹 '$KFC_OVERRIDE_HOSTNAME
        else
            set host_string $KFC_YELLOW_N' 󰍹 '(hostname)
        end
    end

    set -a prompt_string $user_string$host_string$cwd_string
    set -a prompt_string "$git_string"

    # Output
    printf "$prompt_string\n"
    printf "$command_prefix"
end
