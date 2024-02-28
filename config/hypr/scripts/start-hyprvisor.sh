#!/usr/bin/env bash


# killall hyprvisor
~/.cargo/bin/hyprvisor kill
sleep 0.2
~/.cargo/bin/hyprvisor daemon
