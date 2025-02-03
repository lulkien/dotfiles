function cd --wraps=cd --description 'Wrapper function for change directory'
    # Global variables for this SHELL session
    set -q KFC_CD_PREV || set -g KFC_CD_PREV $HOME
    set -q KFC_CD_HISTORY_LEN || set -g KFC_CD_HISTORY_LEN 15

    set -g KFC_CD_HISTORY_FILE "$HOME/.cd_history"
    set -g KFC_CD_HISTORY_TEMP "$KFC_CD_HISTORY_FILE.temp"

    set -g CD_HISTORY

    if not test -f $KFC_CD_HISTORY_FILE
        umask 077
        touch $KFC_CD_HISTORY_FILE
    end

    function __cd_print_help
        echo "Usage: cd [OPTION]"
        echo "  or:  cd [DESTINATION]"
        echo "Change directory to a specific path or a history index."
        echo
        echo "Options:"
        echo "    -l, --list            Show cd history list and jump."
        echo "    -h, --help            Show this help."
    end

    function __cd_update_history

        test -z "$argv"; or test "$argv" = "$HOME"; and return

        begin
            echo "$argv"
            cat "$KFC_CD_HISTORY_FILE"
        end \
            | awk '!seen[$0]++' \
            | head -n $KFC_CD_HISTORY_LEN \
            | tee $KFC_CD_HISTORY_TEMP >/dev/null
        and mv $KFC_CD_HISTORY_TEMP $KFC_CD_HISTORY_FILE

    end

    function __cd_remove_history

        test -z "$argv"; or test "$argv" = "$HOME"; and return

        awk -v line="$argv" '$0 != line' $KFC_CD_HISTORY_FILE \
            | tee $KFC_CD_HISTORY_TEMP >/dev/null
        and mv $KFC_CD_HISTORY_TEMP $KFC_CD_HISTORY_FILE

    end

    function __cd_fetch_history

        set CD_HISTORY

        while read -l line
            set --append CD_HISTORY "$line"
        end <$KFC_CD_HISTORY_FILE

        for idx in (seq 1 (count $CD_HISTORY))
            printf "%d) %s\n" $idx $CD_HISTORY[$idx]
        end

    end

    function __cd_jump
        read -f -p 'printf "#? "' REPLY

        if test $status -ne 0
            echo "Canceled."
            return 1
        end

        if not string match -qr '^[0-9]+$' -- "$REPLY"
            echo "Index must be a number."
            return 1
        end

        if test "$REPLY" -lt 1 -o "$REPLY" -gt (count $CD_HISTORY)
            echo "Index out of range."
            return 1
        end

        echo $CD_HISTORY[$REPLY]
        return 0
    end

    # ------------------ MAIN ---------------------
    set -f cd_destination ""
    set -f _flag_help false
    set -f _flag_list false
    set -f current_dir (pwd)

    if test (count $argv) -gt 1
        echo (set_color red)"cd: "(set_color normal)'Too many arguments.'
        return 1
    end

    switch "$argv"
        case -l --list
            set _flag_list true
        case -h --help
            set _flag_help true
        case '*'
            set cd_destination "$argv"
    end

    if $_flag_help
        __cd_print_help
        return 0
    end

    if $_flag_list

        if not test -s "$KFC_CD_HISTORY_FILE"
            echo (set_color red)"cd: "(set_color normal)'History empty'
            return 1
        end

        __cd_fetch_history

        set -l jump_msg (__cd_jump)
        set -l jump_err $status

        if test $jump_err -ne 0
            echo (set_color red)"cd: "(set_color normal)"$jump_msg"
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
            echo (set_color yellow)"cd: "(set_color normal)"$cd_destination"
        else
            set -l real_path (realpath -q "$cd_destination")
            test $status -eq 0; and set cd_destination "$real_path"
        end

    end

    test "$current_dir" = "$cd_destination"; and return 0

    builtin cd -- "$cd_destination"
    set -f cd_status $status

    # REMOVE HISTORY NO MATTER WHAT
    # BECAUSE OF THAT HISTORY MAY NOT EXIST ANYMORE
    __cd_remove_history "$cd_destination"

    test $cd_status -ne 0; and return $cd_status

    set KFC_CD_PREV "$current_dir"
    __cd_update_history "$cd_destination"

    set -e -g CD_HISTORY

    return 0

end
