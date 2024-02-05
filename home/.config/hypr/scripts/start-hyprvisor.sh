#!/usr/bin/env bash


killall hyprvisor-server
~/.cargo/bin/hyprvisor-server &

sleep 0.2
eww daemon &
eww -c ~/.config/eww/widgets/power-overlay daemon &
eww -c ~/.config/eww/widgets/quick-control daemon &

sleep 0.2
eww open bar &
