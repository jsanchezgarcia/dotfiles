-- [[ Setting options ]]
-- See `:help vim.o` and `:help option-list`

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show the mode (it's in the status line)
vim.o.showmode = false

-- Sync clipboard between OS and Neovim
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10

-- LSP inlay hints styling
vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'NonText' })

-- Raise a dialog asking if you wish to save current file(s)
vim.o.confirm = true

-- Custom tabline to show clean buffer names
vim.o.tabline = '%!v:lua.CleanTabline()'

function _G.CleanTabline()
  local s = ''
  for i = 1, vim.fn.tabpagenr('$') do
    local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
    local bufname = vim.fn.bufname(bufnr)

    -- Handle diff buffers
    if bufname:match('^d///') then
      bufname = 'Diff View'
    else
      bufname = vim.fn.fnamemodify(bufname, ':t')
      if bufname == '' then
        bufname = '[No Name]'
      end
    end

    -- Highlight current tab
    if i == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else
      s = s .. '%#TabLine#'
    end

    s = s .. ' ' .. bufname .. ' '
  end

  s = s .. '%#TabLineFill#'
  return s
end
