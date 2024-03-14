#!/usr/bin/env bash

if [[ ! $(command -v eww) ]]; then
	exit 1
fi

eww kill &
eww -c ~/.config/eww/widgets/power-overlay kill &
eww -c ~/.config/eww/widgets/system-menu kill &

sleep 0.2

eww daemon
eww -c ~/.config/eww/widgets/power-overlay daemon
eww -c ~/.config/eww/widgets/system-menu daemon

sleep 0.1

max_check_attempts=50
attempt=0

# Wait until hyprvisor start
until pidof hyprvisor || [[ $attempt -ge $max_check_attempts ]]; do
	sleep 0.1
	((attempt++))
done

eww open bar
