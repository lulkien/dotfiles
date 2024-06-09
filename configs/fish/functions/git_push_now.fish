function git_push_now --description "Push to current branch"
    # ------------------ INTERNAL FUNCTIONS -------------------- #
    function __interrupt_if_error
        set cmd_status $argv[1]
        if test $cmd_status -ne 0
            echo "Interrupted!"
            return 0
        else
            return 1
        end
    end

    function __print_countdown
        set branch $argv[1]
        set delay 5

        test -z "$branch"; and return
        echo -en "Push commit to branch \e[1;33m$branch\e[00m in "

        while test $delay -gt 0
            echo -n $delay
            set delay (math $delay - 1)
            sleep 0.25

            for idx in (seq 3)
                echo -n '.'
                sleep 0.25
            end
        end
        echo
    end

    # ------------------ MAIN ------------------- #
    # Get current branch
    set current_branch (command git branch --show-current)
    # set current_branch 'HEAD:refs/for/'(command git branch --show-current)

    # Parse arguments
    if test "$argv[1]" = --
        set -f option $argv[2]
    else
        set -f option $argv[1]
    end

    if test "$option" = --skip-countdown
        set -f _flag_skip_countdown
    else if test -n "$option"
        echo "git_push_now: $option: unknown option"
        return 1
    end

    # prompt answer
    set answer ""

    while true
        echo "Push to branch: $current_branch? [yes/no]"
        read -p 'set_color green; printf "Answer: "; set_color normal' answer
        __interrupt_if_error $status; and return 2

        if test "$answer" = yes; or test "$answer" = no
            break
        end
    end

    if test "$answer" = yes
        if not set -q _flag_skip_countdown
            __print_countdown $current_branch
            __interrupt_if_error $status; and return 2
        end
        command git push origin $current_branch
    else
        echo "Canceled!"
    end
end
