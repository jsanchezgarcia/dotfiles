return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = '[G]it Lazy[g]it' },
    { '<leader>gc', '<cmd>LazyGitFilterCurrentFile<cr>', desc = '[G]it [C]ommits (current file)' },
    { '<leader>gl', '<cmd>LazyGitFilter<cr>', desc = '[G]it [L]og (all commits)' },
  },
  config = function()
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_floating_window_border_chars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
    vim.g.lazygit_use_neovim_remote = 1
  end,
}
