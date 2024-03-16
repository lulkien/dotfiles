#!/usr/bin/env bash

pkill hyprpaper
hyprpaper &

pkill hypridle
hypridle &

pkill hyprdim
hyprdim &

pkill ags
ags &

pkill fcitx5
fcitx5 -dr &
