function vim --wraps=nvim --description 'alias vim nvim'
    if command -sq nvim
        nvim $argv
    else
        command vim $argv
    end
end
