#!/usr/bin/env bash

if [[ ! $(command -v wofi ) ]]; then
    exit 1
fi

if [[ $(pidof wofi ) ]]; then
    pkill wofi
else
    wofi
fi
