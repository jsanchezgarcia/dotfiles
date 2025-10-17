. "$HOME/.cargo/env"

# Zoxide fallback for non-interactive shells (like Claude Code)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
else
  function __zoxide_z() {
    builtin cd "$@"
  }
  alias cd='__zoxide_z'
fi
