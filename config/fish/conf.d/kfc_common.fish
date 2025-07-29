function prepend_path
    test -z "$argv[1]"; and return # $argv[1] is zero string
    test -d "$argv[1]"; or return # $argv[1] is not a directory
    contains "$argv[1]" $PATH; or set -xp PATH "$argv[1]" # $PATH does not contains $argv[1]
end

# Reset PATH
set -e PATH

# Export default PATH
set -gx PATH /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin

# Prepend additional PATH
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/go/bin"
prepend_path "$HOME/.cargo/bin"
prepend_path /opt/homebrew/bin
prepend_path /home/linuxbrew/.linuxbrew/bin

# Fish builtin variables
set -g fish_color_valid_path
set -g fish_term24bit 1
set -g fish_greeting

# Recommend for user config
# set -g KFC_SHOW_GIT_STATUS true
# set -g KFC_SHOW_GIT_RELATIVE true
# set -g KFC_SHOW_HOSTNAME true
# set -g fish_greeting    $KFC_GREEN_B"Your greeting message here"
