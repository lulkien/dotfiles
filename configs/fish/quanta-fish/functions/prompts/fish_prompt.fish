function fish_prompt --description 'Write out the prompt'
    set -l cmd_prefix $QF_CL_WHITE_N' > '$QF_CL_RESET
    test $USER = root && set cmd_prefix $QF_CL_RED_N' # '$QF_CL_RESET

    # Start print
    printf '%s' $QF_CL_WHITE_B'[ '
    printf '%s' $QF_CL_CYAN_N$USER
    printf '%s' $QF_CL_WHITE_B'@'
    printf '%s' $QF_CL_GREEN_N(prompt_hostname)
    printf '%s' $QF_CL_PINK_B' :: '
    printf '%s' $QF_CL_YELLOW_N(prompt_pwd)
    printf '%s' $QF_CL_WHITE_B' ]'
    #fish_git_prompt
    singularis_git_prompt
    printf '\n%s' $cmd_prefix
end
