-- note.nvim - Note-taking plugin

return {
  'gsuuon/note.nvim',
  cmd = 'Note',
  ft = 'note',
  opts = {
    spaces = { '~' },
  },
  keys = {
    {
      '<leader>nn',
      function()
        local name = vim.fn.input('Note name: ')
        if name ~= '' then
          -- Replace spaces with underscores
          name = name:gsub(' ', '_')
          vim.cmd('Note ' .. name)
        end
      end,
      desc = '[N]ote [N]ew/open',
    },
    { '<leader>nd', '<cmd>Note daily<cr>', desc = '[N]ote [D]aily' },
    {
      '<leader>nt',
      function()
        require('telescope.builtin').live_grep {
          cwd = require('note.api').current_note_root(),
        }
      end,
      desc = '[N]ote [T]elescope search',
    },
    {
      '<leader>nf',
      function()
        require('telescope.builtin').find_files {
          cwd = require('note.api').current_note_root(),
        }
      end,
      desc = '[N]ote [F]ind files',
    },
  },
}
