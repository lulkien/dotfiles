function git_push_now
    set -f allow_ans        'Y' 'y' 'N' 'n'
    set -f confirm          'Y' 'y'
    set -f current_branch   (command git branch --show-current)
    set -f fail_safe        5   # Wait 5 seconds before push

    echo "Push to branch: $current_branch? [y/n]"
    read ans
    if test $status -ne 0
        echo "Interupted!"
        return
    end

    while not contains -- "$ans" $allow_ans
        echo "Push to branch: $current_branch? [y/n]"
        read ans
        if test $status -ne 0
            echo "Interupted!"
            return
        end
    end

    if contains -- "$ans" $confirm
        echo -n "Push commit to branch $current_branch in "
        while test $fail_safe -gt 0
            echo -n "$fail_safe..."
            set fail_safe (math $fail_safe - 1)
            sleep 1
        end
        echo
        command git push origin $current_branch
        return
    end

    echo "Canceled!"
    return
end
