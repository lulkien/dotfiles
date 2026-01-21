if command -v eza &>/dev/null; then
    abbr -a l eza
    abbr -a ls eza
    abbr -a ll 'eza -lg'
    abbr -a la 'eza -lag'
    abbr -a lt 'eza -lgtmodified'
    abbr -a lat 'eza -lagtmodified'
    abbr -a lta 'eza -lagtmodified'
fi
