if command -sq pacman
    # Package manager
    abbr -a pud     'sudo pacman -Sy'
    abbr -a pug     'sudo pacman -Su --noconfirm'
    abbr -a puf     'sudo pacman -S --noconfirm --needed archlinux-keyring; sudo pacman -Syu'
    abbr -a pit     'sudo pacman -S --noconfirm --needed'
    abbr -a pcl     'sudo pacman -Rns (pacman -Qdttq)'
    abbr -a prm     'sudo pacman -Rns'
    abbr -a pss     'pacman -sS'
    abbr -a pqr     'pacman -Q'
end

if command -sq yay
    abbr -a yuf     'yay -Syu'
    abbr -a yit     'yay -S'
end
