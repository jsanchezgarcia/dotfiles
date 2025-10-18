-- UFO: Advanced folding with preview and visual indicators
return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  event = 'BufRead',
  keys = {
    { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
    { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
    { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Fold less' },
    { 'zm', function() require('ufo').closeFoldsWith() end, desc = 'Fold more' },
    { 'zp', function() require('ufo').peekFoldedLinesUnderCursor() end, desc = 'Peek fold' },
  },
  opts = {
    provider_selector = function()
      return { 'treesitter', 'indent' }
    end,
  },
  config = function(_, opts)
    require('ufo').setup(opts)
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
}
