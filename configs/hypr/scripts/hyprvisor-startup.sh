#!/usr/bin/env bash

if [[ ! -e ~/.cargo/bin/hyprvisor ]]; then
    exit 1
fi

# killall hyprvisor
~/.cargo/bin/hyprvisor kill
sleep 0.2
~/.cargo/bin/hyprvisor daemon
