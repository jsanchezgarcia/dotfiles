if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions BEFORE fzf-tab
autoload -Uz compinit && compinit

# Load fzf-tab AFTER compinit
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

# Completion styling (must be after fzf-tab load but before zoxide init)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Initialize zoxide AFTER fzf-tab config (only in interactive shells)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Add custom scripts to PATH
export PATH="$HOME/scripts:$PATH"

# Aliases
alias ls='ls --color'

alias claude="/Users/juansanchez/.claude/local/claude"
alias ke="pkill -f 'Electron' && pkill -f 'electron'"
alias wt='git-worktree-helper'

# Shell integrations
# Don't use fzf --zsh completion as fzf-tab handles all completion
# Just source key bindings manually
if [[ -f "${FZF_HOME:-$HOME/.fzf}/shell/key-bindings.zsh" ]]; then
  source "${FZF_HOME:-$HOME/.fzf}/shell/key-bindings.zsh"
elif [[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
fi

# Yazi shell integration
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# bun completions
[ -s "/Users/juansanchez/.bun/_bun" ] && source "/Users/juansanchez/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.deno/bin:$PATH"

export EDITOR="cursor"

# API Keys and secrets
# Add your API keys to ~/.zshenv.local (not tracked in git)
[ -f ~/.zshenv.local ] && source ~/.zshenv.local

export PATH="$HOME/.local/bin:$PATH"
export PATH=/Users/juansanchez/.opencode/bin:$PATH

# Cargo environment
. "$HOME/.cargo/env"

#alias cursor='open -a Cursor . && osascript -e "tell application \"Cursor\" to activate"'
source ~/fzf-git.sh/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias lst="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --tree --level=2" 

_gco() {
  local branch
  branch=$(_fzf_git_branches --no-multi) || return
  git checkout "$branch"
}
alias gcob='_gco'  # optional shorthand

# Prompt customization - minimal and clean (must be at the end)
PROMPT='%F{blue}%~%f %# '
RPROMPT=''  # Clear right prompt set by plugins