function str_rand
    set -l lower        'abcdefghijklmnopqrstuvwxyz'
    set -l upper        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    set -l digit        '1234567890'
    set -l special      '!@#$%^&*_-+='

    set -g str_master   ''
    set -g len_master   0

    set -g LEN          $argv[1]
    set -g OPT          $argv[2]
    set -g QTE          $argv[3]
    set -g RET          ''

    set -l ERR          ''

    # logger
    function dbg
        test "$OPT" = '-q';
        and return 0
        test "$QTE" = '-q';
        and return 0
        test "$OPT" = '--quiet';
        and return 0
        test "$QTE" = '--quiet';
        and return 0
        echo $argv[1]
    end

    
    # start process
    test -z $LEN
    and begin
        dbg 'Missing length'
        return 1
    end
    or test $LEN -lt 1
    and begin
        dbg 'Number of character must be greater than 0'
        return 1
    end

    test -z $OPT
    and begin
        dbg 'Missing option params, use all posible characters as default'
        set str_master "$lower$upper$digit$special"
    end

    string match -riq 'l' $OPT; and set str_master "$str_master$lower"
    string match -riq 'u' $OPT; and set str_master "$str_master$upper"
    string match -riq 'd' $OPT; and set str_master "$str_master$digit"
    string match -riq 's' $OPT; and set str_master "$str_master$special"
    set len_master (string length $str_master)

    if [ $len_master -lt 1 ]
        dbg 'Wrong option params, use all possible characters as default'
        set str_master "$lower$upper$digit$special"
    end
    set len_master (string length $str_master)

    # get final string
    for i in (seq 1 $LEN)
        set -l idx (random 1 $len_master)
        set RET "$RET"(string sub -s $idx -l 1 $str_master)
    end

    dbg 'Result:'
    echo $RET
    return 0

end
