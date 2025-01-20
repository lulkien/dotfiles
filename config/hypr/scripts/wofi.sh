#!/usr/bin/env bash

if [[ ! $(command -v wofi ) ]]; then
    exit 1
fi

pkill wofi || wofi
