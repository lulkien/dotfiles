# pam_umask sets 002 for user-private groups; force the classic 022 (dirs 755, files 644)
umask 022

if status is-interactive
end

if test -f $HOME/.config/fish/user.fish
    source $HOME/.config/fish/user.fish
end

# opencode
fish_add_path /home/kiewn/.opencode/bin
