function __cd_int_check
    string match -qr '^\s*[0-9]+' "$argv" && return 0 || return 1
end

function log
    echo $argv >> $HOME/cd.log
end

function __cd_add_history
    set -l new_path       "$argv[1]"
    set -l old_history    (string split --no-empty ' ' "$argv[2]")

    # Remove existed path in history
    set -l new_history    (string match -v $new_path $old_history)

    # Remove oldest item in history if OOM
    # Not implemented yet
    # Someone please help me implement it

    # Unless cd to $HOME, add path to history
    string match -q $HOME $new_path || set new_history $new_path $new_history
    echo $new_history
end

function cd --description "Wrapper function for change directory"
    set -l cd_destination ""
    set -l cd_status 0
    set -l HISTORY_MEM_SIZE 25

    # Init cd_history in new shell
    set -q cd_history || set -g cd_history
    set -q cd_prev_path || set -g cd_prev_path $HOME
    # Parse arguments
    set -l options (fish_opt -s l -l list)
    set -a options (fish_opt -s i -l index --required-val)
    argparse $options -- $argv; or return 1

    # Check if using 2 options
    if set -q _flag_index; and set -q _flag_list
        echo "ERROR: Only use one option at a time"
        return 1
    end

    if set -q _flag_list        # Using list option
        test (count $argv) -gt 0 && echo "WARN: Print dir history only, ignore other arguments"
        set -l index 1
        for dir in $cd_history
            echo "$index - $dir"
            set index (math $index + 1)
        end
        return 0
    else if set -q _flag_index  # If using index option
        if not __cd_int_check $_flag_index
            echo "ERROR: $_flag_index is not an integer"
            return 1
        end
        if test $_flag_index -lt 1 -o $_flag_index -gt (count $cd_history)
            echo "ERROR: Invalid history index"
            return 1
        end
        test (count $argv) -gt 0 && printf "WARN: Change directory to index %s, ignore other arguments" $_flag_index
        set cd_destination $cd_history[$_flag_index]
    else # default case
        if test -z "$argv"
            set cd_destination $HOME
        else if test "$argv" = '-'
            set cd_destination $cd_prev_path
        else
            set cd_destination  (realpath -q $argv)
            set path_stt        $status
            if test $path_stt -ne 0
                printf "ERROR: The directory '%s' not exist\n" $argv
                return 1
            end
        end
    end

    set -l tmp_path (pwd)
    builtin cd $cd_destination
    set cd_status $status
    if test $cd_status -eq 0
        # Save the previous path if new destination is different with the previous
        string match -q "$tmp_path" "$cd_destination" || set cd_prev_path $tmp_path
        set cd_history (__cd_add_history $cd_destination "$cd_history")
        set cd_history (string split --no-empty ' ' "$cd_history")
    end
    return $cd_status
end
