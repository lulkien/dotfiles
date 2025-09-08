function kfc_git_prompt
    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_GIT_DISABLED"
        return
    end

    if ! command -q git
        set -Ux KFC_GIT_DISABLED 1
        return
    end
    
    # Icon
    set -f ico_git $KFC_YELLOW_N''
    set -f ico_detach $KFC_YELLOW_N''
    set -f ico_clean $KFC_GREEN_N''
    set -f ico_dirty $KFC_YELLOW_N''
    set -f ico_untrack $KFC_BLUE_N''
    set -f ico_divergent $KFC_RED_N''
    set -f ico_ahead $KFC_GREEN_N''
    set -f ico_behind $KFC_YELLOW_N''
    set -f ico_arrow $KFC_WHITE_N''

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

    if $bare_repo; and $git_dir
        echo $ico_git' '$KFC_RED_N'bare'
        return
    end

    if $git_dir
        echo $ico_git' '$KFC_RED_N'.git'
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

    $detached
    and set git_string $ico_detach
    or set git_string $ico_git

    set -a git_string $KFC_PURPLE_N$branch_name

    # Fetch relative count
    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_GIT_RELATIVE"
        set -l ahead
        set -l behind

        git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null | read behind ahead
        if test -n "$behind"; and test -n "$ahead"
            if test $ahead -ne 0; and test $behind -ne 0
                set -a git_string $ico_divergent
            else if test $ahead -ne 0
                set -a git_string $ico_ahead' '$ahead
            else if test $behind -ne 0
                set -a git_string $ico_behind' '$behind
            end
        end
    end

    # Fetch git status
    if string match --regex --quiet -- '^(true|yes|ok|1)$' "$KFC_SHOW_GIT_STATUS"
        for stt in $(git status --short | awk '{print $1}' | sort | uniq)
            if string match --regex --quiet -- '[ACDMR]' "$stt"
                set dirty true
            else if test "$stt" = '??'
                set untrack true
            end
        end

        set -a git_string $ico_arrow

        not $dirty
        and not $untrack
        and set -a git_string $ico_clean

        $dirty
        and set -a git_string $ico_dirty

        $untrack
        and set -a git_string $ico_untrack
    end

    echo "$git_string"
end
