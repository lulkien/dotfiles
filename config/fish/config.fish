if status is-interactive
end

if test -f $HOME/.config/fish/user.fish
    source $HOME/.config/fish/user.fish
end

# opencode
fish_add_path /home/kiewn/.opencode/bin
