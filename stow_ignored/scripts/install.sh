# Ask for admin priviledge upfront
sudo -v

# Download brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Download dependencies
xargs brew install < ../my_brews

# Verify everything is installed
./verify.sh

# Install zsh if on linux
if [ "$(uname)" != "Darwin" ]; then
	sudo apt install zsh
fi

# Link stuff in the correct location
cd ~/.dotfiles/ && stow .

# Source tmux config
tmux source ~/.config/tmux/tmux.conf

