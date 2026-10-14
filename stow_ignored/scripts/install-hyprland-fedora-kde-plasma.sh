#!/usr/bin/env bash

# Ask for admin priviledge upfront
sudo -v

sudo dnf copr enable -y lionheartp/Hyprland
sudo dnf copr enable -y imput/helium

# Install packages
PACKAGES=(
	# Compositor + session
	hyprland uwsm xdg-desktop-portal-hyprland qt5-qtwayland qt6-qtwayland
	# Hypr ecosystem: dialogs, Qt6 theming
	# (bar, launcher, notifications, OSD, lock, idle, wallpaper and the polkit prompt come from the Caelestia
	# shell: install-caelestia-fedora-kde-plasma.sh)
	hyprland-guiutils hyprqt6engine
	# Apps used by keybinds
	kitty helium-bin
	# Media keys (wpctl comes from wireplumber)
	wireplumber playerctl
	# Input method (Chinese Pinyin); not fcitx5-autostart, Hyprland's autostart / Plasma's KWin launch it
	fcitx5 fcitx5-chinese-addons fcitx5-gtk fcitx5-qt fcitx5-qt6 fcitx5-configtool kcm-fcitx5
	# From KDE (already present with Plasma): KWallet unlock at login (autostart runs pam_kwallet_init)
	pam-kwallet kf6-kwallet
)
sudo dnf install "${PACKAGES[@]}"

# Manual steps not covered here:
# - Font: Maple Mono NF (used by kitty and the Caelestia shell's mono text) is installed by hand into
#   ~/.local/share/fonts
