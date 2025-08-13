-- plugins/lsp.lua (or your equivalent file)
return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- This is the cmp source for LSP, and it provides the capabilities
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- This is the function that will be called when an LSP attaches to a buffer.
      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end

        -- Keybindings for LSP features.
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('gK', vim.lsp.buf.signature_help, 'Signature Documentation')

        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- ADDED: Keymap for formatting. This will use null-ls or any other LSP that supports formatting.
        if client.supports_method("textDocument/formatting") then
            nmap('<leader>gf', vim.lsp.buf.format, '[G]o [F]ormat Buffer')
        end

        -- The original command is also great to have.
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- The main setup function for mason-lspconfig
      require('mason-lspconfig').setup({
        ensure_installed = {"lua_ls", "clangd", "texlab", "pyright", "hyprls", "marksman"},
        handlers = {
          -- The default handler.
          function(server_name)
            require('lspconfig')[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        },
      })
      
         end
  }
}
