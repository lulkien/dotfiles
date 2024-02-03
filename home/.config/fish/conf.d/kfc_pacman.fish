if command -sq pacman
    # Package manager
    abbr -a pud     'sudo pacman -Sy'
    abbr -a pug     'sudo pacman -Su --noconfirm'

    abbr -a puf     'sudo pacman -S --noconfirm --needed archlinux-keyring; sudo pacman -Syu'
    abbr -a pit     'sudo pacman -S --noconfirm --needed'

    abbr -a prm     'sudo pacman -Rns'
    abbr -a pcl     'sudo pacman -Rns (pacman -Qdttq)'

    abbr -a pqr     'pacman -Q'
    abbr -a pss     'pacman -sS'
end

