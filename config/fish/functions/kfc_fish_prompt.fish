function kfc_fish_prompt
    set ico_dir $KFC_BLUE_B'󰉋'
    set ico_fish $KFC_WHITE_N''$KFC_CL_NONE
    set ico_local $KFC_YELLOW_N'󰍹'
    set ico_ssh $KFC_YELLOW_N''
    set ico_user $KFC_CYAN_N''
    set ico_root $KFC_RED_N''

    # User string
    if test (whoami) = root
        set user_string $ico_root' '$USER
    else
        set user_string $ico_user' '$USER
    end

    # Working directory string
    set cwd_string $ico_dir' '(prompt_pwd --full-length-dirs=2 --dir-length=3)

    # Git string
    set git_string (kfc_git_prompt)

    # Host string
    set host_string ''
    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_HOSTNAME"
        set ico_host
        if set -q SSH_TTY
            set ico_host $ico_ssh
        else
            set ico_host $ico_local
        end

        if set -q KFC_OVERRIDE_HOSTNAME; and test -n "$KFC_OVERRIDE_HOSTNAME"
            set host_string ' '$ico_host' '$KFC_OVERRIDE_HOSTNAME' '
        else
            set host_string ' '$ico_host' '$hostname' '
        end
    end

    # Collect prompt string
    set prompt_top $user_string$host_string$cwd_string' '$git_string

    set prompt_bottom $ico_fish

    # Output
    printf " $prompt_top\n $prompt_bottom "
end
