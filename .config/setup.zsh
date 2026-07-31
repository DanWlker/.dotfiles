HOMEBREW_PREFIX=$(brew --prefix)

if which vivid &>/dev/null; then
	export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

# fzf
if which fzf &>/dev/null; then
	export FZF_DEFAULT_OPTS=" \
		--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
		--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
		--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
		--color=selected-bg:#45475A \
		--color=border:#6C7086,label:#CDD6F4"
	source <(fzf --zsh)
fi

# serie
if which serie &>/dev/null; then
	alias gitgraph="serie"
fi

# btop
if which btop &>/dev/null; then
	alias top="btop"
fi

# delta
if which delta &>/dev/null; then
	alias diff="delta --side-by-side"
fi

# ripgrep (replaces grep)
if which rg &>/dev/null; then
	alias grep="rg --smart-case"
fi

# wget
if which wget &>/dev/null; then
	alias wget='wget -c'
fi

# fd (replaces find)
if which fd &>/dev/null; then
	alias find="fd"
fi

# dust (replaces du)
if which dust &>/dev/null; then
	alias du="dust"
fi

# eza (replaces ls)
if which eza &>/dev/null; then
	alias ls="eza --icons=auto"
	alias tree="eza --icons=auto --tree"
fi

# bat (replaces cat)
if which bat &>/dev/null; then
	# bat will auto remove numbers if piped or subshell
	alias cat="bat"
	alias less='bat --paging=always'
fi

# zoxide (replaces cd)
if which zoxide &>/dev/null; then
	eval "$(zoxide init zsh --cmd cd)"
fi

# direnv
if which direnv &>/dev/null; then
	eval "$(direnv hook zsh)"
fi

# gnu sed (replaces sed)
if which gsed &>/dev/null; then
	alias sed="gsed"
fi

# gawk (replaces awk)
if which gawk &>/dev/null; then
	alias awk="gawk"
fi

# nvim
if which nvim &>/dev/null; then
	alias vim="nvim"
	alias vi="nvim"
fi

# xclip
if which xclip &>/dev/null; then
	alias xclip="xclip -se c"
fi

# bun
if [[ -f "$HOME/.bun/bin/bun" ]]; then
	# bun completions
	[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

	# bun
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

# rust
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# tailscale needs special handling on mac
if [[ -f /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

# yazi
if which yazi &>/dev/null; then
	y() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
		yazi "$@" --cwd-file="$tmp"
		if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
			builtin cd -- "$cwd"
		fi
		rm -f -- "$tmp"
	}
fi

# pnpm
if [[ -d "$HOME/.local/share/pnpm" ]]; then
	export PNPM_HOME="$HOME/.local/share/pnpm"
	case ":$PATH:" in
	  *":$PNPM_HOME/bin:"*) ;;
	  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
	esac
fi

# lazygit
if which lazygit &>/dev/null; then
	alias l="lazygit"
fi

# kubectl
if which kubectl &>/dev/null && which kubecolor &>/dev/null; then
	alias kubectl="kubecolor"
	alias k="kubectl"
fi

# asdf
if which asdf &>/dev/null; then
	if [[ ! -d "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" ]]; then
		echo "Creating completions for asdf"
		mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
		asdf completion zsh >"${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
	fi
	export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
	fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
	if asdf where flutter >/dev/null 2>&1; then
	  export FLUTTER_ROOT="$(asdf where flutter)"
	fi
fi

# mani
if which mani &>/dev/null; then
	# Define where to store mani completions
	MANI_COMPLETIONS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mani/completions"

	# Create and generate completion if missing
	if [[ ! -d "$MANI_COMPLETIONS_DIR" ]]; then
		echo "Creating completions for mani"
		mkdir -p "$MANI_COMPLETIONS_DIR"
		mani completion zsh > "$MANI_COMPLETIONS_DIR/_mani"
	fi

	# Add to fpath for autoloading
	fpath=($MANI_COMPLETIONS_DIR $fpath)
fi

# carapace
if which carapace &>/dev/null; then
	export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
	# zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
	zstyle ':fzf-tab:*' query-string ''
	source <(carapace _carapace)
fi

# go
if which go &>/dev/null; then
	export PATH=$(go env GOPATH)/bin:$PATH
fi

# terraform
if which terraform &>/dev/null; then
	autoload -U +X bashcompinit && bashcompinit
	complete -o nospace -C /Users/zixi.hee/homebrew/bin/terraform terraform
fi

# fzf-tab
if [[ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]]; then
	# disable sort when completing `git checkout`
	zstyle ':completion:*:git-checkout:*' sort false
	# set descriptions format to enable group support
	# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
	zstyle ':completion:*:descriptions' format '[%d]'
	# set list-colors to enable filename colorizing
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
	zstyle ':completion:*' menu no
	# preview directory's content with eza when completing cd
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
	# NOTE: This may lead to unexpected behavior since some flags break this plugin. See https://github.com/Aloxaf/fzf-tab/issues/455
	zstyle ':fzf-tab:*' use-fzf-default-opts yes
	# switch group using tab
	zstyle ':fzf-tab:*' switch-group 'btab' 'tab'
	source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
fi

# zsh-system-clipboard
if [[ -f $HOMEBREW_PREFIX/share/zsh-system-clipboard/zsh-system-clipboard.zsh ]]; then
	source "$HOMEBREW_PREFIX/share/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

# zsh-auto-suggestions
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	unset ZSH_AUTOSUGGEST_USE_ASYNC # To fix incompatibility issue: https://github.com/romkatv/powerlevel10k/issues/1554#issuecomment-1701598955
fi

# zsh-history-substring-search
if [[ -f "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
	export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='none'
	export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='none'
	source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down
fi

# zsh-patina
if [[ -f "$HOMEBREW_PREFIX/bin/zsh-patina" ]]; then
	eval "$($HOMEBREW_PREFIX/bin/zsh-patina activate)"
fi
