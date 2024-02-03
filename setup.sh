#!/usr/bin/env bash

echo "[PREPARE]"
HYPR_CFG=$HOME/.config/hypr
EWW_CFG=$HOME/.config/eww
SWAYLOCK_CFG=$HOME/.config/swaylock
KITTY_CFG=$HOME/.config/kitty
WOFI_CFG=$HOME/.config/wofi
FISH_CFG=$HOME/.config/fish

CFG_LIST=("$HYPR_CFG" "$EWW_CFG" "$SWAYLOCK_CFG" "$KITTY_CFG" "$WOFI_CFG" "$FISH_CFG")

for cfg in "${CFG_LIST[@]}"
do
    test -L $cfg && unlink $cfg || rm -rf $cfg
done


NVIM_CFG=$HOME/.config/nvim
NVCHAD_CFG=$NVIM_CFG/lua
NVCHAD_CUSTOM_CFG=$NVCHAD_CFG/custom

if [[ ! -d $NVIM_CFG ]]; then
    echo "[INSTALL NVCHAD]"
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
else
    if [[ ! -d $NVCHAD_CFG ]]; then
        echo "[REMOVE OLD NVIM AND INSTALL NVCHAD]"
        rm -rf $NVIM_CFG
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    else
        test -L $NVCHAD_CUSTOM_CFG && unlink $NVCHAD_CUSTOM_CFG || rm -rf $NVCHAD_CUSTOM_CFG
    fi
fi

echo "[RUN STOW]"
if ! command -v stow &> /dev/null
then
    echo "[INSTALL STOW]"
    sudo pacman -S stow
fi

DOT_PATH=$(realpath "$(dirname $0)")
stow --verbose=2 --dir=$DOT_PATH/home --target=$HOME .
