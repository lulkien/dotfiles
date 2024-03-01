# Append some paths into PATH variable
set -a PATH $HOME/.cargo/bin
set -a PATH $HOME/.local/bin
set -a PATH /opt/homebrew/bin

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
