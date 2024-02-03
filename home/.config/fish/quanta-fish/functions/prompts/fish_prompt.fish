function fish_prompt --description 'Write out the prompt'
    set -f _start_prompt    $QF_CL_WHITE_B' '
    set -f _end_prompt      $QF_CL_WHITE_B' '

    set -f _user            $QF_CL_CYAN_N' '$USER
    set -f _cwd             $QF_CL_BLUE_N' 󰉋 '(prompt_pwd --full-length-dirs=2 --dir-length=2)
    set -f _git_str         (singularis_git_prompt)

    set -f _cmd_prefix      $QF_CL_WHITE_N' 󰶻  '$QF_CL_RESET

    # OVERRIDE ROOT PREFIX IS A BAD IDEA, TRUST ME
    if test $USER = 'root'
        set _cmd_prefix     $QF_CL_RED_N' # 󰶻  '$QF_CL_RESET
    end

    # Construct prompt
    set -f _prompt_string   $_start_prompt$_user$_cwd$_git_str$_end_prompt

    # Output
    printf "$_prompt_string\n"
    printf "$_cmd_prefix"
end
