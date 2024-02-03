function git_push_now
    set -f allow_ans        'Y' 'y' 'N' 'n'
    set -f confirm          'Y' 'y'
    set -f current_branch   (command git branch --show-current)

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
        git push origin $current_branch
    else
        echo "Canceled!"
        return
    end
end
