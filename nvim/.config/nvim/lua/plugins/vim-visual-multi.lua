return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = 'VeryLazy',
  init = function()
    vim.g.VM_maps = {
      ['Find Under'] = '<C-n>',
      ['Find Subword Under'] = '<C-n>',
      ['Select All'] = '<C-A-n>',
      ['Skip Region'] = 'q',
      ['Remove Region'] = 'Q',
    }
  end,
}
