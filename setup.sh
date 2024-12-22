#!/usr/bin/env bash

# Env
PATH=/opt/homebrew/bin:$PATH

# Source path
script_path=$(realpath "$(dirname $0)")
all_configs=${script_path}/configs

# MacOS check
is_darwin=false
if test $(uname -s) = 'Darwin'; then
    is_darwin=true
fi

# Root check
is_root_user=false
if test $(whoami) = 'root'; then
    is_root_user=true
fi

# Config directory
user_config_dir=${HOME}/.config

# choices
options=('Hyprland' 'General Desktop Environment' 'Windows Subsystem for Linux' 'Cancel')

# Define list of configurations for every options
hypr_conf=('hypr' 'eww' 'anyrun' 'kitty' 'dunst')
general_conf=('kitty')
wsl_conf=
mac_conf=('kitty')
root_conf=

# Default list of configurations which every options have
configs=('fish' 'nvim' 'neovide' 'bash')

# If setup for hyprland
is_hyprland=false

# --------------------------------------------------------------------------------------------------------------------------------------------

function setup_dotfiles {
    if test $(pwd) != "${script_path}"; then
        echo "[DEBUG] cd ${script_path}"
        cd ${script_path}
        echo "--------------------------------------"
    fi

    echo "[INFO] Backup or unlink old config"
    for config in "${configs[@]}"; do
        local conf_path=${user_config_dir}/${config}
        local conf_path_bak=${user_config_dir}/${config}.bak

        if [[ -L $conf_path ]]; then
            echo "[DEBUG] unlink $conf_path"
            unlink $conf_path
        elif [[ -d $conf_path ]]; then
            rm -rf $conf_path_bak
            echo "[DEBUG] Rename: $conf_path -> $conf_path_bak"
            mv $conf_path $conf_path_bak
        fi
    done
    echo "--------------------------------------"

    echo "[INFO] Symlink new configs"
    for config in "${configs[@]}"; do
        echo "[DEBUG] Create symlink: ${user_config_dir}/${config} -> ${all_configs}/${config}"
        ln -s ${all_configs}/${config} ${user_config_dir}/${config}
    done
    echo "--------------------------------------"
}

function post_hyprland_config {
    echo "[INFO] Run post config for Hyprland"

    # Setup icons
    local user_icons=$HOME/.local/share/icons
    local hyprcursor_packages=$script_path/packages/hyprcursor

    if [[ ! -d $user_icons ]]; then
        echo "[DEBUG] mkdir -p $user_icons"
        mkdir -p $user_icons
    fi

    for pgk in $hyprcursor_packages/*.tar.gz; do
        echo "[DEBUG] tar -xzf $pgk -C $user_icons"
        tar -xzf $pgk -C $user_icons
    done

    # Setup fonts
    local user_fonts="$HOME/.fonts"

    if [[ ! -d $user_fonts ]]; then
        echo "[DEBUG] mkdir -p $user_fonts"
        mkdir -p $user_fonts
    fi

    echo "[DEBUG] cp -r $script_path/packages/fonts/Anurati $user_fonts"
    cp -r $script_path/packages/fonts/Anurati $user_fonts
    fc-cache -fv

    # Setup bin
    local user_bin="$HOME/.local/bin"
    if [[ ! -d ${user_bin} ]]; then
        echo "[DEBUG] mkdir -p ${user_bin}"
        mkdir -p ${user_bin}
    fi

    if [[ -L $user_bin/Hyprland ]]; then
        unlink $user_bin/Hyprland
    elif [[ -e $user_bin/Hyprland ]]; then
        mv $user_bin/Hyprland $user_bin/Hyprland.bak
    fi

    ln -s $script_path/bin/Hyprland $user_bin/Hyprland
}

function main {
    if $is_root_user; then
        echo -e '\e[1;32mTarget: \e[00mRoot'
        # keep configs for root
    elif $is_darwin; then
        echo -e '\e[1;32mTarget: \e[00mMacOS'
        configs+=("${mac_conf[@]}")
    else
        echo -e '\e[1;32mSelect target:\e[00m'
        select opt in "${options[@]}"; do
            case $REPLY in
            1)
                echo -e "\e[1;32mTarget: \e[00m${opt}"
                is_hyprland=true
                configs+=("${hypr_conf[@]}")
                break
                ;;
            2)
                echo -e "\e[1;32mTarget: \e[00m${opt}"
                configs+=("${general_conf[@]}")
                break
                ;;
            3)
                echo -e "\e[1;32mTarget: \e[00m${opt}"
                # keep configs for WSL
                break
                ;;
            4)
                echo -e "\e[1;33mCanceled\e[00m"
                exit 0
                ;;
            *)
                echo -e "\e[1;31mInvalid\e[00m"
                exit 1
                ;;
            esac
        done
    fi

    sleep 0.5
    echo
    echo -e '\e[1;32mThe following configs will be linked:\e[00m'
    for conf in "${configs[@]}"; do
        echo " - $conf"
    done

    sleep 0.5
    echo -e '\e[1;33mAre you sure?\e[00m [y/N]'
    read -r -p 'Answer: ' response

    echo
    case "${response,,}" in
    y)
        echo -e '\e[1;32mSetting up...\e[00m'
        setup_dotfiles
        if $is_hyprland; then
            post_hyprland_config
        fi
        echo
        echo -e '\e[1;32mCompleted.\e[00m'
        ;;
    *)
        echo -e '\e[1;33mCanceled\e[00m'
        exit 0
        ;;
    esac
}

# ------------------------------------------------------------------------------------------------------------

main
