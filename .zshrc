# fzf
# ripgrep (replaces grep)
# stow
# tldr
# fd (replaces find)

# dust
alias du="dust"

# eza
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# bat (replaces cat)
alias cat="bat -p"

# zoxide (replaces cd)
eval "$(zoxide init zsh --cmd cd)"

# atuin
eval "$(atuin init zsh)"

# zsh-vi-mode
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_VI_EDITOR=nvim

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
