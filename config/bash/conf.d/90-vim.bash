if command -v nvim &>/dev/null; then
    abbr -a vi nvim
    abbr -a vim nvim
    export EDITOR=nvim
fi
