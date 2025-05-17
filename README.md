# Get Started

## Installation

### Auto install

Run the install.sh script

```
~/.dotfiles/stow_ignored/scripts/install.sh
```

### Manual Installation

```
git clone https://github.com/DanWlker/.dotfiles.git --recurse-submodules
```

If you already have the repo cloned:

```
git submodule update --init --remote --recursive
```

Install dependencies

```
xargs -n brew install < $HOME/.dotfiles/stow_ignored/brews/mac
xargs -n brew install < $HOME/.dotfiles/stow_ignored/brews/common
```

To check whether everything is installed successfully, run

```
~/.dotfiles/stow_ignored/scripts/verify.sh $HOME/.dotfiles/stow_ignored/brews/mac
~/.dotfiles/stow_ignored/scripts/verify.sh $HOME/.dotfiles/stow_ignored/brews/common
```

Once everything is installed correctly run

```
cd .dotfiles && stow .
```

Restart your shell, tmux should launch

After tmux launches, press `prefix + I`, to install plugins (that is capital I)

## Maintenance

After you made changes to the submodule .config/nvim:

```
cd .config/nvim
git add <stuff>
git commit -m <message>
git push origin HEAD:master
cd .dotfiles
git add .config/nvim
git commit -m <message>
git push
```

If submodule changes don't appear when you run `git status`:

```
git submodule update --remote --merge
```

To export

```
brew leaves > my_brews
```
