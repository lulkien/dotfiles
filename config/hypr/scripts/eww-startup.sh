#!/usr/bin/env bash

if [[ ! $(command -v eww ) ]]; then
    exit 1
fi

eww kill &
eww -c ~/.config/eww/widgets/power-overlay kill &
eww -c ~/.config/eww/widgets/quick-control kill &

sleep 0.2

eww daemon
eww -c ~/.config/eww/widgets/power-overlay daemon
eww -c ~/.config/eww/widgets/quick-control daemon

sleep 0.1

local max_check_attempts=50
local attempt=0

# Wait until hyprvisor start
until pidof hyprvisor || [[ $attempt -ge $max_check_attempts ]]; do
    sleep 0.1
    ((attempt++))
done

eww open bar
