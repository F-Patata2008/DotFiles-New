return {
  {
    -- Snippet Engine
    "L3MON4D3/LuaSnip",
    dependencies = {
      -- Provides a bunch of useful snippets
      "rafamadriz/friendly-snippets",
    },
    -- Optional: lazy-load snippets for faster startup
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    -- Autocompletion Engine
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Load nvim-cmp only when you enter insert mode
    dependencies = {
      -- Source for nvim-lsp completions
      "hrsh7th/cmp-nvim-lsp",
      -- Source for buffer completions
      "hrsh7th/cmp-buffer",
      -- Source for path completions (taken from your first config)
      "hrsh7th/cmp-path",
      -- Source for command-line completions
      "hrsh7th/cmp-cmdline",
      -- Source for LuaSnip snippets
      "saadparwaiz1/cmp_luasnip",
      -- Adds nice icons to completion items
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection with Enter

          -- "Smart" Tab behavior
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- The sources nvim-cmp will use for suggestions, in order of priority
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
        }),
        -- Custom formatting with icons
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- show symbol and text
            maxwidth = 50,
            ellipsis_char = '...',
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            }
          }),
        },
      })
    end
  }
}
