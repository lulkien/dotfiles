function vim --description 'Use vim alternative if possible'
    if command -sq neovide
        neovide $argv
    else if command -sq nvim
        nvim $argv
    else
        command vim $argv
    end
end
