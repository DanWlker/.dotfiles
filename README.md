# Get Started

## Installation

Clone the repo

```
git clone https://github.com/DanWlker/.dotfiles.git --recurse-submodules
```

If you already have the repo cloned:

```
git submodule update --init --remote --recursive
```

### Auto install

#### Brew

1. Run the [install-with-brew.sh](./stow_ignored/scripts/install-with-brew.sh) script, this will auto install brew as well

1. Start your shell as zsh, tmux should launch

1. After tmux launches, press `prefix + I`, to install plugins (that is capital I)

### Manual Installation

#### Brew

1. Install brew

1. Install dependencies

   ```
   xargs -n brew install < $HOME/.dotfiles/stow_ignored/brews/mac
   xargs -n brew install < $HOME/.dotfiles/stow_ignored/brews/common
   ```

1. To check whether everything is installed successfully, run

   ```
   ~/.dotfiles/stow_ignored/scripts/verify.sh $HOME/.dotfiles/stow_ignored/brews/mac
   ~/.dotfiles/stow_ignored/scripts/verify.sh $HOME/.dotfiles/stow_ignored/brews/common
   ```

1. Once everything is installed correctly run

   ```
   cd .dotfiles && stow .
   ```

1. Start your shell as zsh, tmux should launch

1. After tmux launches, press `prefix + I`, to install plugins (that is capital I)

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
