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

