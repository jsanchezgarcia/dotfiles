return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>-',
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at current file',
    },
    {
      '<leader>cw',
      '<cmd>Yazi cwd<cr>',
      desc = 'Open yazi at working directory',
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
  },
}
