function cd --wraps=cd --description 'Wrapper function for change directory'
    # Global variables for this SHELL session
    set -q KFC_CD_HISTORY || set -g --path KFC_CD_HISTORY
    set -q KFC_CD_PREV || set -g KFC_CD_PREV $HOME
    set -q KFC_CD_HISTORY_LEN || set -g KFC_CD_HISTORY_LEN 15

    function __cd_print_help
        echo "Usage: cd [OPTION]"
        echo "  or:  cd [DESTINATION]"
        echo "Change directory to a specific path or a history index."
        echo
        echo "Options:"
        echo "    -j, --jump            Show cd jump list."
        echo "    -l, --list            Print cd history list."
        echo "    -h, --help            Show this help."
    end

    function __cd_update_history
        test -z "$argv"; or test "$argv" = "$HOME"; and return

        set -p KFC_CD_HISTORY "$argv"
    end

    function __cd_remove_history
        test -z "$argv"; or test "$argv" = "$HOME"; and return

        set -f --path new_history
        set -f history_len 0

        for item in $KFC_CD_HISTORY
            test "$item" = "$argv"; and continue

            set history_len (math $history_len + 1)
            test $history_len -ge $KFC_CD_HISTORY_LEN; and break

            set -a new_history "$item"
        end

        set KFC_CD_HISTORY $new_history
    end

    function __cd_print_list
        set -f index 1
        for history_path in $KFC_CD_HISTORY
            echo "$index) $history_path"
            set index (math $index + 1)
        end
    end

    function __cd_jump
        set -f history_len (count $KFC_CD_HISTORY)

        if test $history_len -eq 0
            echo "Jump: History empty"
            return 2
        end

        read -f -p 'printf "#? "' jump_index
        if not string match --quiet --regex -- '^-*[0-9]+$' "$jump_index"
            echo "Jump: Index must be a number."
            return 2
        end

        if test $jump_index -lt 1; or test $jump_index -gt $history_len
            echo "Jump: Index out of range."
            return 2
        end

        echo "$KFC_CD_HISTORY[$jump_index]"
        return 0
    end

    # ------------------ MAIN ---------------------
    set -f cd_destination ""
    set -f _flag_help false
    set -f _flag_jump false
    set -f _flag_list false
    set -f current_dir (pwd)

    if test (count $argv) -gt 1
        echo "cd: Too many arguments."
        return 1
    end

    switch "$argv"
        case -j --jump
            set _flag_jump true
        case -h --help
            set _flag_help true
        case -l --list
            set _flag_list true
        case '*'
            set cd_destination "$argv"
    end

    if $_flag_help
        __cd_print_help
        return 0
    end

    if $_flag_list
        __cd_print_list
        return 0
    end

    if $_flag_jump
        __cd_print_list

        set -l jump_msg (__cd_jump)
        set -l jump_err $status

        if test $jump_err -ne 0
            echo "cd: $jump_msg"
            return $jump_err
        end

        set cd_destination "$jump_msg"
        echo ----------------------------
        echo (set_color yellow)"cd: "(set_color normal)"$cd_destination"
    else
        if test -z "$cd_destination"
            set cd_destination "$HOME"
        else if test "$cd_destination" = -
            set cd_destination "$KFC_CD_PREV"
        else
            set -l real_path (realpath -q "$cd_destination")
            test $status -eq 0; and set cd_destination "$real_path"
        end
    end

    test "$current_dir" = "$cd_destination"; and return 0

    builtin cd -- "$cd_destination"
    set -f cd_status $status

    # remove history no matter what
    # because of that history may not exist anymore
    __cd_remove_history "$cd_destination"

    test $cd_status -ne 0; and return $cd_status

    set KFC_CD_PREV "$current_dir"
    __cd_update_history "$current_dir"

    return 0
end
