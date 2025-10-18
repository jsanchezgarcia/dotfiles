-- Neovim Configuration
-- A clean, modular setup based on kickstart.nvim

-- Load core configuration
require 'config.options' -- Editor options and settings
require 'config.keymaps' -- Key mappings
require 'config.autocmds' -- Autocommands

-- Bootstrap and configure lazy.nvim plugin manager
-- This will automatically load all plugins from lua/plugins/*.lua
require 'config.lazy'

-- vim: ts=2 sts=2 sw=2 et
