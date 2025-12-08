#!/usr/bin/env bash

# Ask for admin priviledge upfront
sudo -v

read -rp "Enter your package install command (e.g. 'sudo apt install -y'): " INSTALL_CMD
read -rp "Enter your package update command (or leave blank to skip e.g. 'sudo apt-get update'): " UPDATE_CMD

# Run update if provided
if [[ -n "$UPDATE_CMD" ]]; then
	eval "$UPDATE_CMD"
fi

# Install packages
eval "$INSTALL_CMD hyprland hyprlock hyprpaper"
