# Append some paths into PATH variable
if not contains "$HOME/.cargo/bin" $PATH
    set -Uxp PATH $HOME/.cargo/bin
end

if not contains "$HOME/.local/bin" $PATH
    set -Uxp PATH $HOME/.local/bin
end

if not contains /opt/homebrew/bin $PATH
    set -Uxp PATH /opt/homebrew/bin
end

# Set editor
if command -sq nvim
    set -Ux EDITOR nvim
end

# Abbreviations
abbr -a chmox 'chmod +x'
abbr -a rmc 'rm ~/.config/fish/fish_variables'
abbr -a rf 'rm -rf'

# Fish builtin variables
set -g fish_color_valid_path
set -g fish_term24bit 1
set -g fish_greeting

# Recommend for user config
# set -g KFC_GIT_STATUS true
# set -g KFC_GIT_RELATIVE_COUNT true
# set -g fish_greeting    $KFC_GREEN_B"ARMORED RESPONSE COALITION - TOGETHER WE SURVIVE"
