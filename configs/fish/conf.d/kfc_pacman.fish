if not command -sq pacman
    return
end

set -l pac_wapper "sudo pacman"
if command -sq paru
    set pac_wapper paru
end

# Package manager
abbr -a pit "$pac_wapper -S --noconfirm --needed"
abbr -a prm "$pac_wapper -Rns"
abbr -a puf "$pac_wapper -S --noconfirm --needed archlinux-keyring; $pac_wapper -Syu"
abbr -a pcl "$pac_wapper -Rns (pacman -Qdttq)"

abbr -a pqr 'pacman -Q'
abbr -a pss 'pacman -sS'
