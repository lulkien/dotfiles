function vim --description 'Use vim alternative if possible'
    if command -q neovide
        neovide $argv
    else if command -q nvim
        nvim $argv
    else if set -q EDITOR
        command $EDITOR $argv
    else
        command vim $argv
    end
end
