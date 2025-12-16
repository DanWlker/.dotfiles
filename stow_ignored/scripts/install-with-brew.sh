#!/usr/bin/env bash

# Ask for admin priviledge upfront
sudo -v

# Install zsh if on linux
if [[ "$(uname)" == "Linux" ]]; then
	read -rp "Enter your package install command (e.g. 'sudo apt install -y'): " INSTALL_CMD
	read -rp "Enter your package update command (or leave blank to skip e.g. 'sudo apt-get update'): " UPDATE_CMD

	# Run update if provided
	if [[ -n "$UPDATE_CMD" ]]; then
		eval "$UPDATE_CMD"
	fi

	# Install packages
	if [[ -n "$INSTALL_CMD" ]]; then
		eval "$INSTALL_CMD curl zsh gcc git xclip coreutils"
	fi
fi

# Download brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [[ -d "/opt/homebrew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "$HOME/.linuxbrew" ]]; then
	eval "$("$HOME"/.linuxbrew/bin/brew shellenv)"
elif [[ -d "/home/linuxbrew" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

chmod +x "$HOME/.dotfiles/stow_ignored/scripts/verify.sh"

VERIFY_PATH=$HOME/.dotfiles/stow_ignored/scripts/verify.sh

# Install mac specific ones first
if [[ "$(uname)" == "Darwin" ]]; then
	MAC_BREW_PATH=$HOME/.dotfiles/stow_ignored/brews/mac
	xargs -n 1 brew install <"$MAC_BREW_PATH"
	$VERIFY_PATH "$MAC_BREW_PATH"
fi

# Install common ones
COMMON_BREW_PATH=$HOME/.dotfiles/stow_ignored/brews/common
xargs -n 1 brew install <"$COMMON_BREW_PATH"
$VERIFY_PATH "$COMMON_BREW_PATH"

# Link stuff in the correct location
cd ~/.dotfiles/ && stow .

# bat refresh theme cache
bat cache --build

# tmux install plugins
# not tested, check here if it doesn't work https://github.com/tmux-plugins/tpm/issues/6
"$HOME"/.tmux/plugins/tpm/bin/install_plugins
