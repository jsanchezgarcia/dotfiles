# Dotfiles

Personal configuration files managed with GNU Stow.

## Contents

- **nvim** - Neovim configuration with LSP, completions, and plugins
- **ghostty** - Ghostty terminal emulator configuration
- **kitty** - Kitty terminal configuration
- **lazygit** - Lazygit TUI configuration
- **yazi** - Yazi file manager configuration
- **zsh** - Zsh shell configuration (.zshrc, .zshenv, .zprofile)
- **tmux** - Tmux configuration
- **git** - Git configuration

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- Install on macOS: `brew install stow`

## Installation

1. Clone this repository:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

2. Backup your existing configs (if any):
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.zshrc ~/.zshrc.backup
# ... backup other configs as needed
```

3. Use stow to symlink configurations:
```bash
# Install all configurations
stow */

# Or install specific configurations
stow nvim
stow zsh
stow git
```

## Uninstallation

To remove symlinks created by stow:
```bash
# Remove all configurations
stow -D */

# Or remove specific configurations
stow -D nvim
stow -D zsh
```

## Structure

Each directory represents a "package" for GNU Stow. The directory structure mirrors your home directory:

```
dotfiles/
├── nvim/
│   └── .config/
│       └── nvim/
├── zsh/
│   ├── .zshrc
│   ├── .zshenv
│   └── .zprofile
└── ...
```

When you run `stow nvim`, it creates symlinks:
- `~/.config/nvim` → `~/dotfiles/nvim/.config/nvim`

## Notes

- After installing nvim config, run `:Lazy sync` to install plugins
- Zsh config requires [zinit](https://github.com/zdharma-continuum/zinit) (auto-installed on first run)

### Managing Secrets

API keys and sensitive environment variables should be stored in `~/.zshenv.local` (not tracked in git):

```bash
# ~/.zshenv.local
export ANTHROPIC_API_KEY="your-key-here"
export OPENAI_API_KEY="your-key-here"
```

This file is automatically sourced by .zshrc if it exists.
