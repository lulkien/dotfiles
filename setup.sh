#!/usr/bin/env bash

DOT_PATH=$(realpath "$(dirname $0)")

echo ">>> CHANGE DIRECTORY TO ${DOT_PATH}"
cd ${DOT_PATH}
echo "--------------------------------------"


echo ">>> BACKUP OLD CONFIG"
HYPR_CFG=${HOME}/.config/hypr
EWW_CFG=${HOME}/.config/eww
SWAYLOCK_CFG=${HOME}/.config/swaylock
KITTY_CFG=${HOME}/.config/kitty
WOFI_CFG=${HOME}/.config/wofi
FISH_CFG=${HOME}/.config/fish

CFG_LIST=("${HYPR_CFG}" "${EWW_CFG}" "${SWAYLOCK_CFG}" "${KITTY_CFG}" "${WOFI_CFG}" "${FISH_CFG}")

for CFG in "${CFG_LIST[@]}"
do
    if test -L ${CFG}; then
        unlink ${CFG}
    else
        rm -rf ${CFG}.bak
        mv ${CFG} ${CFG}.bak
    fi
done
echo "--------------------------------------"


NVIM_CFG=${HOME}/.config/nvim
NVCHAD_CFG=${NVIM_CFG}/lua
NVCHAD_CUSTOM_CFG=${NVCHAD_CFG}/custom

if [[ ! -d ${NVIM_CFG} ]]; then
    echo ">>> INSTALL NVCHAD"
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    echo "--------------------------------------"
else
    if [[ ! -d ${NVCHAD_CFG} ]]; then
        echo ">>> REMOVE OLD NVIM CONFIG THEN INSTALL NVCHAD"
        rm -rf ${NVIM_CFG}.bak
        mv ${NVIM_CFG} ${NVIM_CFG}.bak
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
        echo "--------------------------------------"
    else
        if test -L ${NVCHAD_CUSTOM_CFG}; then
            unlink ${NVCHAD_CUSTOM_CFG}
        else
            rm -rf ${NVCHAD_CUSTOM_CFG}.bak
            mv ${NVCHAD_CUSTOM_CFG} ${NVCHAD_CUSTOM_CFG}.bak
        fi
    fi
fi

if ! command -v stow &> /dev/null
then
    echo ">>> INSTALL STOW"
    sudo pacman -S stow
    echo "--------------------------------------"
fi

echo ">>> RUN STOW"
stow --dir=${DOT_PATH}/home --target=${HOME} .
echo "--------------------------------------"

echo ">>> GIT UPDATE SUBMODULES"
git submodule update --init --recursive
echo "--------------------------------------"

echo "PLEASE INSTALL THE SUBMODULES YOURSELF."
