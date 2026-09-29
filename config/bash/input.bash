# Abbreviation expansion hooks (see builtins/abbr.bash). Only useful when
# readline is running, so sourcing this from a script stays quiet.
if [[ $- == *i* ]]; then

    # Space expands an abbreviation in command position, otherwise it is just
    # a space.
    bind -x '" ":_abbr_on_space'

    # Ctrl-Space inserts a literal space and leaves the word alone, so a word
    # an abbreviation matches stays unexpanded.
    bind -x '"\C-@":_abbr_literal_space'

    # Enter expands too, through a macro: \C-x\C-b runs the expansion and
    # \C-x\C-m is accept-line. accept-line cannot be bound to \C-m directly
    # because the macro would re-enter itself instead of accepting the line.
    bind -x '"\C-x\C-b":_abbr_before_accept'
    bind '"\C-x\C-m": accept-line'
    bind '"\C-m": "\C-x\C-b\C-x\C-m"'

fi
