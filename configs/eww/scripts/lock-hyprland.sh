#!/usr/bin/env bash

sleep 0.3
pidof hyprlock || hyprlock &
disown
