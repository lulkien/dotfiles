cwd() {
    local dir_trim=2
    local dir_size=3

    if [[ "$KBC_PROMPT_DIR_TRIM" =~ ^[0-9]+$ ]]; then
        dir_trim=$KBC_PROMPT_DIR_TRIM
    fi

    if [[ "$KBC_PROMPT_DIR_SIZE" =~ ^[0-9]+$ ]]; then
        dir_size=$KBC_PROMPT_DIR_SIZE
    fi

    local perl_cmd="print join( '/', map { \$i++ < @F - ${dir_trim} ? substr \$_,0,${dir_size} : \$_ } @F)"

    pwd | sed "s#$HOME#~#" | perl -F/ -ane "$perl_cmd"
}
