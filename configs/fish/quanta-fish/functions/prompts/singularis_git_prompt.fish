function ___singularis_git_info
    set gitdir           $argv[1]
    set inside_gitdir    $argv[2]
    set bare_repo        $argv[3]    # no use
    set inside_workspace $argv[4]    # no use
    set -q argv[5]; and set  sha $argv[5]
    set branch   ''
    set detached false

    if test $inside_gitdir = true
        set branch $QF_CL_YELLOW_B'.GIT'
    else
        set branch (command git branch --show-current)
        if test -z $branch
            set detached true
            if set -q sha
                set branch $QF_CL_CYAN_N(string shorten -m8 -c "" -- $sha)
                # set branch (string sub -s 1 -l 8 -- $sha) # compatible with older fish
            else
                set branch $QF_CL_WHITE_B'unknown'
            end
        else
            set branch $QF_CL_PINK_B$branch
        end
    end

    echo $branch
    echo $detached
end

function ___singularis_worktree_status
    set  sha              $argv[1]
    if not test -n "$sha"
        echo false
        echo false
        echo 'invalid'
        return
    end
    # Assume we are inside the worktree
    set git_status       (command git -c core.fsmonitor= status --porcelain -z -unormal | string split0)
    set dirty            (string match -qr '^\s*[ACDMR]' -- $git_status; and echo true; or echo false)
    set untracked        (string match -qr '^\?\?' -- $git_status;     and echo true; or echo false)

    echo $dirty
    echo $untracked
    echo 'valid'
end

function ___singularis_worktree_prompt
    set -l worktree_status  (___singularis_worktree_status $argv[1])
    set -l dirty_state      $worktree_status[1]
    set -l untracked_state  $worktree_status[2]
    set -l valid_state      $worktree_status[3]

    # Invalid case
    if test $valid_state = 'invalid'
        echo $QF_CL_RED_N'[!]'
        return
    end

    # Clean case
    if test $dirty_state != true; and test $untracked_state != true
        echo $QF_CL_GREEN_N'[ok]'
        return
    end

    # Both case
    if test $dirty_state = true; and test $untracked_state = true
        echo $QF_CL_YELLOW_N'[*]'$QF_CL_PURPLE_N'[%]'
        return
    end

    # Normal case
    if test $dirty_state = true
        echo $QF_CL_YELLOW_N'[*]'
    else
        echo $QF_CL_PURPLE_N'[%]'
    end
end

function ___singularis_relative_upstream
    set -l count (command git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | string replace \t " ")
    echo $count | read -l behind ahead
    switch "$count"
    case '' # no upstream
        echo ''
    case "0 0" # equal to upstream
        echo ''
    case "0 *" # ahead of upstream
        echo $QF_CL_GREEN_N'[+'$ahead']'
    case "* 0" # behind upstream
        echo $QF_CL_RED_N'[-'$behind']'
    case '*' # diverged from upstream
        echo $QF_CL_YELLOW_N' [?]'
    end
end

function singularis_git_prompt
    # Git is not installed, return
    if not command -sq git
        return
    end
    set repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"; or return # cannot get repo_info, just return

    set gitdir              $repo_info[1]
    set inside_gitdir       $repo_info[2]
    set bare_repo           $repo_info[3]
    set inside_workspace    $repo_info[4]
    set HEAD_SHA            $repo_info[5]

    set git_info            (___singularis_git_info $repo_info)
    set current_branch      $git_info[1]
    set detached            $git_info[2]
    set git_label           ''

    if test $inside_gitdir = true
        set git_label       $QF_CL_RED_B'!!'
    else
        if contains -- $detached yes true 1
            set git_label   $QF_CL_YELLOW_B'HEAD'
        else
            set git_label   $QF_CL_YELLOW_B'branch'
        end
    end

    set -f worktree_prompt         ''
    set -f relative_upstream       ''
    if test $inside_workspace = true
        and "$QF_SHOW_GIT_PROMPT_STATUS" = true
        set worktree_prompt ' '(___singularis_worktree_prompt $HEAD_SHA)
        if not contains -- $detached yes true 1
            and test "$QF_SHOW_GIT_RELATIVE_COUNT" = true
            # Find relative upstream if not detached
            # and QF_ALLOW_GIT_RELATIVE_COUNT is true
            set relative_upstream (___singularis_relative_upstream)
        end
    end

    echo -n $QF_CL_ORANGE_N' -> '$QF_CL_WHITE_B'{ '$current_branch$worktree_prompt$relative_upstream$QF_CL_WHITE_B' }'
end
