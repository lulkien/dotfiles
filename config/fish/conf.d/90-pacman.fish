if not command -sq pacman
    return
end

set -l PACMAN_CMD "sudo pacman"

if test (whoami) = root
    set -l PACMAN_CMD pacman
else
    if command -sq aura
        set PACMAN_CMD aura
    else if command -sq paru
        set PACMAN_CMD paru
    else if command -sq yay
        set PACMAN_CMD yay
    end
end

# Package manager
abbr -a pit "$PACMAN_CMD -S --noconfirm --needed"
abbr -a puf "$PACMAN_CMD -S --noconfirm --needed archlinux-keyring; $PACMAN_CMD -Syu"
abbr -a prm "$PACMAN_CMD -Rns"
abbr -a pcl "$PACMAN_CMD -Rns (pacman -Qdttq)"
abbr -a pqr "$PACMAN_CMD -Q"
abbr -a pss "$PACMAN_CMD -sS"
