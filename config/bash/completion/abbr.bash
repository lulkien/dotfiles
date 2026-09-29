# Completion for abbr: positions after --position, keys after --erase/--show,
# options otherwise.
_abbr_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}

    case "${COMP_WORDS[COMP_CWORD - 1]}" in
    -p | --position)
        mapfile -t COMPREPLY < <(compgen -W "$KBC_ABBR_POSITION_DEFAULT anywhere" -- "$cur")
        ;;
    -e | --erase | -s | --show)
        mapfile -t COMPREPLY < <(compgen -W "${!KBC_ABBR_MAP[*]}" -- "$cur")
        ;;
    *)
        mapfile -t COMPREPLY < <(compgen -W "-a --add -p --position -e --erase -s --show -l --list -v --verbose -h --help" -- "$cur")
        ;;
    esac
}

complete -F _abbr_complete abbr
