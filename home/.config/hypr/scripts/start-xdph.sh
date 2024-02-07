#!/usr/bin/env bash

sleep 1
systemctl restart --user xdg-desktop-portal-hyprland.service

sleep 2
systemctl restart --user xdg-desktop-portal.service
