#!/usr/bin/env bash

# Env
PATH=/opt/homebrew/bin:$PATH
IS_DARWIN=$(test $(uname -s) = 'Darwin' && echo true || echo false)
IS_ROOT=$(test $USER = root && echo true || echo false)

# Source path
DOT_PATH=$(realpath "$(dirname $0)")
ALL_CONFIG=${DOT_PATH}/config
TARGET_HOME=${DOT_PATH}/target_home
TARGET_CONFIG=${TARGET_HOME}/.config

# Config home
XDG_CONFIG_HOME=${HOME}/.config
NVIM_CONFIG=${XDG_CONFIG_HOME}/nvim
NVCHAD_CONFIG=${NVIM_CONFIG}/lua
NVCHAD_USER=${NVCHAD_CONFIG}/custom

setup_dotfiles ()
{
    TARGET=$1

    if test -z ""; then
        echo "[INFO] Setup dotfiles"
    else
        echo "[INFO] Setup dotfiles for $TARGET"
    fi
    echo "--------------------------------------"

    if test $(pwd) != $DOT_PATH; then
        echo "[DEBUG] cd $DOT_PATH"
        cd ${DOT_PATH}
        echo "--------------------------------------"
    fi

    echo "[INFO] Remake target config"
    if test -d ${TARGET_HOME}; then
        rm -r ${TARGET_HOME}
    fi

    mkdir -p ${TARGET_CONFIG}
    for CONFIG in "${CONFIG_LIST[@]}"; do
        echo "[DEBUG] Link: ${ALL_CONFIG}/${CONFIG} -> ${TARGET_CONFIG}"
        ln -s ${ALL_CONFIG}/${CONFIG} ${TARGET_CONFIG}
    done
    echo "--------------------------------------"

    echo "[INFO] Backup or unlink old config"
    for CONFIG in "${CONFIG_LIST[@]}"
    do
        if [[ -L ${XDG_CONFIG_HOME}/${CONFIG} ]]; then
            echo "[DEBUG] unlink ${XDG_CONFIG_HOME}/${CONFIG}"
            unlink ${XDG_CONFIG_HOME}/${CONFIG}
        elif [[ -d ${XDG_CONFIG_HOME}/${CONFIG} ]]; then
            echo "[DEBUG] Rename: ${XDG_CONFIG_HOME}/${CONFIG} -> ${XDG_CONFIG_HOME}/${CONFIG}.bak"
            rm -rf ${XDG_CONFIG_HOME}/${CONFIG}.bak
            mv ${XDG_CONFIG_HOME}/${CONFIG} ${XDG_CONFIG_HOME}/${CONFIG}.bak
        fi
    done
    echo "--------------------------------------"

    echo -n "[INFO] Do you want to setup NvChad? [y/N] "
    read nvchad_confirm
    case "$nvchad_confirm" in
        'y'|'Y')
            setup_nvchad
            ;;
        *)
            echo "Hmm, nah."
            ;;
    esac
    echo "--------------------------------------"

    echo "[INFO] Start stow --verbose=2 --dir=${TARGET_HOME} --target=${HOME} ."
    echo
    stow --verbose=2 --dir=${TARGET_HOME} --target=${HOME} .
    echo "--------------------------------------"

    if test "$TARGET" = 'Hyprland'; then
        echo "[INFO] Init submodules for Hyprland"
        git submodule update --init --recursive
        echo "--------------------------------------"

        echo "[WARN] Please install all submodules for Hyprland."
    fi

    echo
    echo "[INFO] Completed."
}

setup_nvchad ()
{
    if [[ ! -d ${NVIM_CONFIG} ]]; then
        echo "[INFO] Install NvChad"
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
        echo
    else
        if [[ ! -d ${NVCHAD_CONFIG} ]]; then
            echo "[INFO] Backup old Neovim config and install NvChad"
            echo "[DEBUG] ${NVIM_CONFIG} -> ${NVIM_CONFIG}.bak"
            rm -rf ${NVIM_CONFIG}.bak
            mv ${NVIM_CONFIG} ${NVIM_CONFIG}.bak
            git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
            echo
        else
            if [[ -L ${NVCHAD_USER} ]]; then
                echo "[DEBUG] unlink ${NVCHAD_USER}"
                unlink ${NVCHAD_USER}
            elif [[ -d ${NVCHAD_USER} ]]; then
                echo "[DEBUG] ${NVCHAD_USER} -> ${NVCHAD_USER}.bak"
                rm -rf ${NVCHAD_USER}.bak
                mv ${NVCHAD_USER} ${NVCHAD_USER}.bak
            fi
        fi
    fi

    echo "[DEBUG] Link: ${ALL_CONFIG}/nvim -> ${TARGET_CONFIG}"
    ln -s ${ALL_CONFIG}/nvim ${TARGET_CONFIG}
}

main ()
{
    if ! command -v stow &> /dev/null
    then
        echo "[ERROR] stow: command not found. Please install stow first."
        return 1
    fi

    CONFIG_TARGET=''

    if test ${IS_ROOT} = true; then
        CONFIG_LIST=( "fish" )
        CONFIG_TARGET=''
    elif test ${IS_DARWIN} = true; then
        CONFIG_LIST=( "fish" "alacritty" )
        CONFIG_TARGET='MacOS'
    else
        echo "Target number:"
        echo "1: For Hyprland."
        echo "2: For KDE, GNOME, etc."
        echo "_: Cancel"
        echo -n "Select: "
        read answer

        case "${answer}" in
            1)
                CONFIG_LIST=( "eww" "fish" "hypr" "kitty" "swaylock" "wofi" "alacritty" )
                CONFIG_TARGET='Hyprland'
                ;;
            2)
                CONFIG_LIST=( "fish" "kitty" )
                CONFIG_TARGET=''
                ;;
            *)
                echo "Canceled."
                return 0
                ;;
        esac
    fi

    setup_dotfiles $CONFIG_TARGET
}

main
