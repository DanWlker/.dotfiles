# fzf
# ripgrep
# stow
# tldr

# dust
alias du="dust"

# eza
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# bat
alias cat="bat -p"

# zoxide
eval "$(zoxide init zsh)"
alias cd="z"
alias cc="z -"

# atuin
eval "$(atuin init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
