# Cursor Configuration

This directory contains Cursor IDE settings managed via GNU Stow.

## Setup

1. **Backup existing settings** (recommended):
   ```bash
   cp -r ~/Library/Application\ Support/Cursor/User ~/Library/Application\ Support/Cursor/User.backup
   ```

2. **Remove original files** to allow stow to create symlinks:
   ```bash
   rm ~/Library/Application\ Support/Cursor/User/settings.json
   rm ~/Library/Application\ Support/Cursor/User/keybindings.json
   ```

3. **Install with stow** from the dotfiles directory:
   ```bash
   cd ~/dotfiles
   stow cursor
   ```

4. **Restart Cursor IDE**

## What's Included

- `settings.json` - Editor settings and preferences
- `keybindings.json` - Custom keyboard shortcuts

## Structure

This package creates symlinks in `~/Library/Application Support/Cursor/User/` pointing to the files in this dotfiles directory:

```
~/Library/Application Support/Cursor/User/settings.json -> ~/dotfiles/cursor/Library/Application Support/Cursor/User/settings.json
~/Library/Application Support/Cursor/User/keybindings.json -> ~/dotfiles/cursor/Library/Application Support/Cursor/User/keybindings.json
```

## Verify It's Working

Check that the symlinks are in place:
```bash
ls -la ~/Library/Application\ Support/Cursor/User/
```

You should see `settings.json` and `keybindings.json` as symlinks (indicated by `->`) pointing to your dotfiles directory.

Any changes made in Cursor will now be automatically tracked in your dotfiles!
