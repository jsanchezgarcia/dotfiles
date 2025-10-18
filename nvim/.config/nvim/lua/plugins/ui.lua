-- UI and appearance plugins

return {
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
        on_highlights = function(hl, c)
          hl.DiffAdd = { bg = '#1a3d2d' }
          hl.DiffChange = { bg = '#3d1f2d' }
          hl.DiffDelete = { bg = '#3d1f2d', fg = '#6d3d4d' }
          hl.DiffText = { bg = '#1a3d2d' }
        end,
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
      { '\\', ':Neotree reveal toggle<CR>', desc = 'NeoTree reveal toggle', silent = true },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  },
}
