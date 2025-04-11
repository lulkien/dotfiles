function fish_prompt --description 'Write out the prompt'
    set padding_string ' '
    set ico_dir '󰉋'
    set ico_fish ''
    set ico_host '󰍹'
    set ico_ssh ''
    set ico_user ''

    # User string
    test $USER = root
    and set user_string $KFC_RED_N$ico_user
    or set user_string $KFC_CYAN_N$ico_user

    set -a user_string $USER

    # Working directory string
    set cwd_string $KFC_BLUE_N'󰉋 '(prompt_pwd --full-length-dirs=2 --dir-length=3)

    # Git string
    set git_string (kfc_git_prompt)

    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_HOSTNAME"
        set -q SSH_TTY
        and set host_string $KFC_YELLOW_N''
        or set host_string $KFC_YELLOW_N'󰍹'

        if set -q KFC_OVERRIDE_HOSTNAME; and test -n "$KFC_OVERRIDE_HOSTNAME"
            set -a host_string $KFC_OVERRIDE_HOSTNAME
        else
            set -a host_string $hostname
        end
    end

    set -a prompt_string "$user_string"
    set -a prompt_string "$host_string"
    set -a prompt_string "$cwd_string"
    set -a prompt_string "$git_string"

    set -a command_prefix $KFC_WHITE_N' '$KFC_CL_NONE

    # Output
    printf "$padding_string$prompt_string\n$padding_string$command_prefix"
end
