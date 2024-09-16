function cd --wraps=cd --description 'Wrapper function for change directory'
    # Init cd_history in new shell
    set -q kfc_cd_history || set -g --path kfc_cd_history
    set -q cd_prev_path || set -g cd_prev_path $HOME
    set -q KFC_CD_HISTORY_LEN || set -g KFC_CD_HISTORY_LEN 15


    # ----------------- INTERNAL FUNCTIONS ------------------
    function __cd_int_check
        # string match -qr '^\s*[0-9]+' "$argv" && return 0 || return 1
        string match -qr '^\s*[0-9]+' "$argv"
    end

    function __cd_update_history
        set path "$argv[1]"
        if test -z "$path"; or test "$path" = "$HOME"
            return
        end

        set -p kfc_cd_history $path
    end

    function __cd_remove_history
        set path "$argv[1]"
        if test -z "$path"; or test "$path" = "$HOME"
            return
        end

        set old_history $kfc_cd_history

        # Clean history
        set kfc_cd_history
        set history_len 0

        # Update history
        for item in $old_history
            if test "$item" = "$path"
                continue
            end

            set history_len (math $history_len + 1)
            if test $history_len -ge $KFC_CD_HISTORY_LEN
                # I don't think we need to remember that much history
                break
            end

            set -a kfc_cd_history "$item"
        end
    end

    function __cd_print_history
        set index 1
        for path in $kfc_cd_history
            echo "$index - $path"
            set index (math $index + 1)
        end
    end

    # ------------------ MAIN ---------------------
    set cd_destination

    # Parse arguments
    set -l options (fish_opt -s l -l list)
    set -a options (fish_opt -s i -l index --required-val)
    argparse $options -- $argv; or return 1

    # Check if using 2 options
    if set -q flag_index; and set -q flag_list
        echo "cd: Only use one option at a time"
        return 1
    end

    # Using list option
    if set -q _flag_list
        if test (count $argv) -gt 0
            echo "cd: Print dir history only, ignore other arguments"
        end
        __cd_print_history
        return 0
    end

    # If using index option
    if set -q _flag_index
        if not __cd_int_check $_flag_index
            echo "cd: $_flag_index is not an integer"
            return 1
        end

        # if test $_flag_index -lt 1 -o $_flag_index -gt (count $kfc_cd_history)
        if test $_flag_index -lt 1; or test $_flag_index -gt (count $kfc_cd_history)
            echo "cd: Invalid index"
            return 1
        end

        if test (count $argv) -gt 0
            echo "cd: Change directory to index $_flag_index, ignore other arguments"
        end

        set cd_destination $kfc_cd_history[$_flag_index]
    else
        # default case
        if test -z "$argv"
            set cd_destination $HOME
        else if test "$argv" = -
            set cd_destination $cd_prev_path
        else
            set cd_destination (realpath -q $argv)
            if test $status -ne 0
                # This should be unreachable!
                echo "cd: Fail to get realpath of $argv"
                return 1
            end
        end
    end

    set cwd (pwd)
    if test "$cwd" = "$cd_destination"
        return 0
    end

    # Actual cd to the destination
    builtin cd $cd_destination
    set cd_status $status

    # Alway remove the destination out of the history no matter what
    __cd_remove_history $cd_destination

    # Update new history if the cd return SUCCESS
    if test $cd_status -eq 0
        set cd_prev_path $cwd
        __cd_update_history $cd_prev_path
    end

    # return cd result code
    return $cd_status
end
