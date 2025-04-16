# Append some paths into PATH variable
if not contains "$HOME/.cargo/bin" $PATH
    set -xp PATH $HOME/.cargo/bin
end

if not contains "$HOME/go/bin" $PATH
    set -xp PATH $HOME/go/bin
end

if not contains "$HOME/.local/bin" $PATH
    set -xp PATH $HOME/.local/bin
end

if not contains /opt/homebrew/bin $PATH
    set -xp PATH /opt/homebrew/bin
end

# Set editor
if command -sq nvim
    set -x EDITOR nvim
end

# Fish builtin variables
set -g fish_color_valid_path
set -g fish_term24bit 1
set -g fish_greeting

# Recommend for user config
# set -g KFC_SHOW_GIT_STATUS true
# set -g KFC_SHOW_GIT_RELATIVE true
# set -g fish_greeting    $KFC_GREEN_B"Your greeting message here"
