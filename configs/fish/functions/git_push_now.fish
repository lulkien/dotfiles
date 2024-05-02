function ___kfc_git_push_delay
    set -l branch $argv[1]
    set -l delay 5

    test -z "$branch"; and return

    # Print message
    echo -en "Push commit to branch \e[1;33m$branch\e[00m in "

    # Print number -> sleep 0.25 -> print . . .
    while test $delay -gt 0
        echo -n $delay
        set delay (math $delay - 1)
        sleep 0.25

        set -l dot_timer 3
        while test $dot_timer -gt 0
            echo -n '.'
            set dot_timer (math $dot_timer - 1)
            sleep 0.25
        end
    end
    echo
end

function git_push_now --description "Push to current branch"
    set -f allow_ans Y y N n
    set -f confirm Y y
    set -f current_branch (command git branch --show-current)
    set -f opts $argv[1]

    echo "Push to branch: $current_branch? [y/n]"
    read -p 'set_color green; printf "Answer: "; set_color normal' ans
    if test $status -ne 0
        echo "Interupted!"
        return
    end

    while not contains -- "$ans" $allow_ans
        echo "Push to branch: $current_branch? [y/n]"
        read -p 'set_color green; printf "Answer: "; set_color normal' ans
        if test $status -ne 0
            echo "Interupted!"
            return
        end
    end

    if contains -- "$ans" $confirm
        if test "$opts" != --yolo
            ___kfc_git_push_delay $current_branch
            if test $status -ne 0
                echo
                echo "Interupted!"
                return
            end
        end
        command git push origin $current_branch
        return
    end

    echo "Canceled!"
    return
end
