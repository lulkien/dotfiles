function fish_add_path_if_existed 
    test -z "$argv[1]"; and return # $argv[1] is zero string
    test -d "$argv[1]"; or return # $argv[1] is not a directory
    fish_add_path "$argv[1]"
end

fish_add_path_if_existed "$HOME/.local/bin"
fish_add_path_if_existed "$HOME/go/bin"
fish_add_path_if_existed "$HOME/.cargo/bin"
fish_add_path_if_existed /opt/homebrew/bin
fish_add_path_if_existed /home/linuxbrew/.linuxbrew/bin

# Fish builtin variables
set -g fish_color_valid_path
set -g fish_term24bit 1
set -g fish_greeting

# Recommend for user config
# set -g KFC_SHOW_GIT_STATUS true
# set -g KFC_SHOW_GIT_RELATIVE true
# set -g KFC_SHOW_HOSTNAME true
# set -g fish_greeting    $KFC_GREEN_B"Your greeting message here"
