-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode with a shortcut
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Neo-tree toggle
vim.keymap.set('n', '<C-n>', ':Neotree filesystem toggle float<CR>')

-- Window navigation is handled by smart-splits.nvim plugin

-- Tab navigation
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = 'Create new [T]ab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'Close current [T]ab' })
vim.keymap.set('n', '[t', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<CR>', { desc = 'Next tab' })

-- Dashboard
vim.keymap.set('n', '<leader>h', '<cmd>Alpha<CR>', { desc = 'Go to [H]ome dashboard' })
