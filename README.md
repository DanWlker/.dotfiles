# Get Started

    git clone https://github.com/DanWlker/.dotfiles.git --recurse-submodules

If you already have the repo cloned:

    git submodule update --init --remote --recursive

Clone this repo to your home directory ~/ then run

    cd .dotfiles
    stow .

After you made changes to the submodule .config/nvim:

    cd .config/nvim
    git add <stuff>
    git commit -m <message>
    git push origin HEAD:master
    cd .dotfiles
    git add .config/nvim 
    git commit -m <message>
    git push

If submodule changes don't appear when you run `git status`:

    git submodule update --remote --merge

To reinstall everything that is listed in my_brews, use the command below:

    brew install $(cat my_brews)

Install [rust](https://www.rust-lang.org/tools/install) (for blink cmp neovim)

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Install [zsh-system-clipboard](https://github.com/kutsan/zsh-system-clipboard)
```
git clone https://github.com/kutsan/zsh-system-clipboard ${ZSH_CUSTOM:-~/.zsh}/plugins/zsh-system-clipboard
```

After tmux launches, press `prefix + I`, to install plugins (that is capital I)
