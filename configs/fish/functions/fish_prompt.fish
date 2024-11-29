function fish_prompt --description 'Write out the prompt'
    set prompt_string ''

    set user_string $KFC_CYAN_N' '(whoami)
    set cwd_string $KFC_BLUE_N' 󰉋 '(prompt_pwd --full-length-dirs=2 --dir-length=3)
    set git_string (kfc_git_prompt)

    set command_prefix $KFC_WHITE_N'   '$KFC_CL_NONE

    # OVERRIDE ROOT PREFIX IS A BAD IDEA, TRUST ME
    if test (whoami) = root
        set command_prefix $KFC_RED_N' #   '$KFC_CL_NONE
    end

    # Check being remoted via ssh
    if set -q SSH_TTY
        set prompt_string $KFC_RED_N"[Remote]"
    end

    set -a prompt_string $user_string$cwd_string
    set -a prompt_string "$git_string"

    # Output
    printf "$prompt_string\n"
    printf "$command_prefix"
end
