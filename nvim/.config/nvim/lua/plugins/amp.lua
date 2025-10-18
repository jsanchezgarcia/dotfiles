return {
  'sourcegraph/amp.nvim',
  branch = 'main',
  lazy = false,
  opts = {
    auto_start = true,
    log_level = 'info',
  },
  config = function(_, opts)
    require('amp').setup(opts)

    local message = require('amp.message')

    vim.api.nvim_create_user_command('AmpPromptRef', function(cmd_opts)
      local bufname = vim.api.nvim_buf_get_name(0)
      local relative_path = vim.fn.fnamemodify(bufname, ':.')

      local ref
      if cmd_opts.range == 2 then
        if cmd_opts.line1 == cmd_opts.line2 then
          ref = string.format('@%s#L%d', relative_path, cmd_opts.line1)
        else
          ref = string.format('@%s#L%d-%d', relative_path, cmd_opts.line1, cmd_opts.line2)
        end
      else
        ref = '@' .. relative_path
      end

      local success = message.send_to_prompt(ref)
      if not success then
        vim.notify('Failed to send to Amp prompt. Is the server running?', vim.log.levels.WARN)
      else
        vim.notify('Sent to Amp: ' .. ref, vim.log.levels.INFO)
      end
    end, { range = true })

    vim.api.nvim_create_user_command('AmpPromptSelection', function(cmd_opts)
      local lines = vim.api.nvim_buf_get_lines(0, cmd_opts.line1 - 1, cmd_opts.line2, false)
      local text = table.concat(lines, '\n')
      local success = message.send_to_prompt(text)
      if not success then
        vim.notify('Failed to send to Amp prompt. Is the server running?', vim.log.levels.WARN)
      else
        vim.notify('Sent selection to Amp', vim.log.levels.INFO)
      end
    end, { range = true })

    vim.keymap.set('n', '<leader>ar', '<cmd>AmpPromptRef<CR>', {
      desc = 'Add file reference to Amp prompt',
      silent = true,
    })

    vim.keymap.set('v', '<leader>ar', ":'<,'>AmpPromptRef<CR>", {
      desc = 'Add file/selection reference to Amp prompt',
      silent = true,
    })

    vim.keymap.set('v', '<leader>as', ":'<,'>AmpPromptSelection<CR>", {
      desc = 'Add selected text to Amp prompt',
      silent = true,
    })
  end,
}
