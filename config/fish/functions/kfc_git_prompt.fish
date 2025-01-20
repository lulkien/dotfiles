function kfc_git_prompt
    # Git precheck
    set -f bare_repo
    set -f git_dir
    set -f work_tree

    git rev-parse --is-bare-repository --is-inside-git-dir --is-inside-work-tree 2>/dev/null | tr '\n' ' ' | read bare_repo git_dir work_tree

    set bare_repo (string trim "$bare_repo")
    set git_dir (string trim "$git_dir")
    set work_tree (string trim "$work_tree")

    if test -z "$bare_repo"; or test -z "$git_dir"; or test -z "$work_tree"
        return
    end

    $bare_repo && $git_dir &&
        begin
            echo $KFC_YELLOW_N''$KFC_RED_N' bare'
            return
        end

    $git_dir &&
        begin
            echo $KFC_YELLOW_N''$KFC_RED_N' .git'
            return
        end

    $work_tree || return

    # Fetch branch
    set -f branch_name (git branch 2>/dev/null | grep -E '^\*.*$' | sed 's#^\* \(.*\)$#\1#')
    set -f detached false
    set -f dirty false
    set -f untrack false
    set -f git_string

    test -z "$branch_name" && return
    if string match -rq -- '\(HEAD detached at (.*)\)' "$branch_name"
        set branch_name (string match --regex --groups-only -- '\(HEAD detached at (.*)\)' "$branch_name")
        set detached true
    end

    if $detached
        set git_string $KFC_YELLOW_N' '$KFC_PINK_N$branch_name
    else
        set git_string $KFC_YELLOW_N' '$KFC_PURPLE_N$branch_name
    end

    # Fetch relative count
    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_GIT_RELATIVE"
        set -l ahead
        set -l behind

        git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | read behind ahead
        if test -n "$behind"; and test -n "$ahead"
            if test $ahead -ne 0; and test $behind -ne 0
                set git_string $git_string' '$KFC_RED_N''
            else if test $ahead -ne 0
                set git_string $git_string' '$KFC_GREEN_N' '$ahead
            else if test $behind -ne 0
                set git_string $git_string' '$KFC_YELLOW_N' '$behind
            end
        end
    end

    # Fetch git status
    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_GIT_STATUS"
        for stt in $(git status --short | awk '{print $1}' | uniq)
            if string match --regex --quiet -- '[ACDMR]' "$stt"
                set dirty true
            else if test "$stt" = '??'
                set untrack true
            end
        end

        set git_string $git_string$KFC_WHITE_N' '
        if not $dirty && not $untrack
            set git_string $git_string' '$KFC_GREEN_N''
        end

        if $dirty
            set git_string $git_string' '$KFC_YELLOW_N''
        end

        if $untrack
            set git_string $git_string' '$KFC_BLUE_N''
        end
    end

    echo "$git_string"
end
