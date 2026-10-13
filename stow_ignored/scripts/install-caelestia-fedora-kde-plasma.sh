#!/usr/bin/env bash
# Dependencies for the trimmed Caelestia shell fork (.config/quickshell/caelestia).
# Run after install-hyprland-fedora-kde-plasma.sh (needs the lionheartp/Hyprland COPR for quickshell).
# Plan: stow_ignored/docs/caelestia-migration.md

# Ask for admin priviledge upfront
sudo -v

sudo dnf copr enable -y lionheartp/Hyprland

# Install packages
PACKAGES=(
	# Build tools for the shell's C++ plugin and m3shapes
	cmake ninja-build gcc-c++
	qt6-qtbase-devel qt6-qtbase-private-devel qt6-qtdeclarative-devel qt6-qtshadertools-devel
	lm_sensors-devel
	# Runtime (quickshell from the COPR; Fedora's own is too old)
	quickshell qt6-qtimageformats ddcutil brightnessctl NetworkManager lm_sensors libxml2
	# Screenshot editor and screen recorder (wf-recorder instead of gpu-screen-recorder on Asahi);
	# wl-clipboard copies screenshots, slurp picks recording regions (also pulled in by the portal)
	swappy wf-recorder wl-clipboard slurp
	# Clock/workspace font
	google-rubik-fonts
)
sudo dnf install "${PACKAGES[@]}"

# Icon font: Material Symbols Rounded isn't packaged in Fedora
mkdir -p "$HOME/.local/share/fonts"
curl -L -o "$HOME/.local/share/fonts/MaterialSymbolsRounded.ttf" \
	'https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL,GRAD,opsz,wght%5D.ttf'
fc-cache -f

# m3shapes (Material 3 shapes QML module, not packaged): build into ~/.local
# Loaded by the shell through QML_IMPORT_PATH=~/.local/lib/qt6/qml
M3SHAPES_SRC=$(mktemp -d)
git clone https://github.com/soramanew/m3shapes "$M3SHAPES_SRC"
cmake -S "$M3SHAPES_SRC" -B "$M3SHAPES_SRC/build" -G Ninja -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX="$HOME/.local" -DCMAKE_INSTALL_LIBDIR=lib
cmake --build "$M3SHAPES_SRC/build"
cmake --install "$M3SHAPES_SRC/build"
rm -rf "$M3SHAPES_SRC"

# Manual steps not covered here:
# - Build the shell plugin into ~/.local (see the plan doc)
# - Not installed on purpose: power-profiles-daemon, fish, libqalculate, aubio, libcava, pipewire-devel
#   (the fork removed the code that needed them)
