#!/usr/bin/env bash

sleep 0.4
pidof hyprlock || hyprlock &
disown
