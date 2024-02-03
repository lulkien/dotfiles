# Abbreviations
abbr -a chmox   'chmod +x'
abbr -a rmc     'rm ~/.config/fish/fish_variables'
abbr -a rf      'rm -rf'

# Map nvim to vim because of muscle memory
if command -sq nvim
    alias vim nvim
end

# Fish builtin variables
set -g fish_color_valid_path
set -g fish_greeting
set -g fish_term24bit               1

# Append some paths into PATH variable
set -a PATH     $HOME/.cargo/bin
set -a PATH     $HOME/.local/bin
