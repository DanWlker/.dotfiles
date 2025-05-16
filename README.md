# Get Started

## Installation

```
git clone https://github.com/DanWlker/.dotfiles.git --recurse-submodules
```

If you already have the repo cloned:

```
git submodule update --init --remote --recursive
```

To install everything that is listed in my_brews, use the command below:

```
xargs brew install < ~/.dotfiles/stow_ignored/my_brews
```

OR

~brew install $(cat \~/.dotfiles/stow_ignored/my_brews)~

To check whether everything is installed successfully, run

```
~/.dotfiles/stow_ignored/scripts/verify.sh
```

Once everything is installed correctly run

    cd .dotfiles
    stow .

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
