function ranger --description "Start ranger with nvim"
    if not command -sq ranger
        printf "Ranger is not installed!\nTry: sudo pacman -S ranger\n"
        return
    end
    if command -sq nvim
        EDITOR=nvim VISUAL=nvim /usr/bin/ranger $argv
    else
        command ranger $argv
    end
end
