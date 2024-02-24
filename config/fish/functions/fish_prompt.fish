function fish_prompt --description 'Write out the prompt'
    set -f _start_prompt $KFC_WHITE_B' '$KFC_CL_NONE
    set -f _end_prompt $KFC_WHITE_B' '$KFC_CL_NONE

    set -f _user $KFC_CYAN_N' '$USER
    set -f _cwd $KFC_BLUE_N' 󰉋 '(prompt_pwd --full-length-dirs=2 --dir-length=2)
    set -f _git_str (kfc_git_prompt)

    set -f _cmd_prefix $KFC_WHITE_N' 󰶻  '$KFC_CL_NONE

    # OVERRIDE ROOT PREFIX IS A BAD IDEA, TRUST ME
    if test $USER = root
        set _cmd_prefix $KFC_RED_N' # 󰶻  '$KFC_CL_NONE
    end

    # Construct prompt
    set -f _prompt_string $_start_prompt$_user$_cwd$_git_str$_end_prompt

    # Output
    printf "$_prompt_string\n"
    printf "$_cmd_prefix"
end
