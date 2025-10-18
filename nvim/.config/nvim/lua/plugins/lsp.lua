-- LSP Configuration

return {
  -- Lua LSP for Neovim config
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- JSON schemas for config files
  {
    'b0o/schemastore.nvim',
  },

  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason: Automatically install LSPs and tools
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- Completion capabilities
      'saghen/blink.cmp',
    },
    config = function()
      -- LSP keymaps (set when LSP attaches to buffer)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Keymaps
          map('K', vim.lsp.buf.hover, 'Hover')
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Diagnostics
          map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
          map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
          map('<leader>dg', vim.diagnostic.setloclist, 'Diagnostics in Location List')
          map('<leader>q', vim.diagnostic.setqflist, 'Diagnostics in Quickfix List')

          -- Other utilities
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
          map('<leader>f', function()
            vim.lsp.buf.format {
              async = true,
              filter = function(client)
                return client.name == 'biome'
              end,
            }
          end, 'Format with Biome')

          -- Format on save with Biome
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.format {
                async = false,
                filter = function(client)
                  return client.name == 'biome'
                end,
              }
            end,
          })

          -- Helper function for method support check
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Highlight references under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            -- disable inlay hints by default
            local _ok = pcall(vim.lsp.inlay_hint.enable, false, { bufnr = event.buf })
            if not _ok then
              pcall(vim.lsp.inlay_hint.enable, event.buf, false)
            end
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Close floating windows (like hover) with Escape
      vim.keymap.set('n', '<Escape>', function()
        local wins = vim.api.nvim_list_wins()
        for _, win in ipairs(wins) do
          if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, true)
          end
        end
      end, { desc = 'Close floating window' })

      -- Diagnostic configuration
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }

      -- LSP client capabilities: start with defaults, then extend with blink.cmp
      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('blink.cmp').get_lsp_capabilities()
      )
      -- Explicitly advertise inlay hint support to servers
      capabilities.textDocument = capabilities.textDocument or {}
      if capabilities.textDocument.inlayHint == nil then
        capabilities.textDocument.inlayHint = { dynamicRegistration = false }
      end

      -- LSP servers to install and configure
      local servers = {
        -- TypeScript/JavaScript
        ts_ls = {
          init_options = {
            preferences = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        -- Biome (linting and formatting)
        biome = {},

        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- Ensure servers and tools are installed
      local lsp_servers = vim.tbl_keys(servers or {})
      local tools = {
        'stylua', -- Lua formatter
        'markdownlint', -- Markdown linter
      }
      local all_tools = vim.tbl_extend('keep', lsp_servers, tools)
      require('mason-tool-installer').setup { ensure_installed = all_tools }
      require('mason-lspconfig').setup {
        ensure_installed = lsp_servers,
        automatic_installation = false,
      }

      -- Manually setup each server using vim.lsp.config (nvim 0.11+)
      for server_name, server_config in pairs(servers) do
        local server = vim.tbl_deep_extend('force', {}, server_config)
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
      end
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },
}
