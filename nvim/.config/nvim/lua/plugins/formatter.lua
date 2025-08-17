-- lua/plugins/formatter.lua

return {
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        logging = true,
        filetype = {
          lua = {
            -- Use the default stylua configuration
            require("formatter.defaults").stylua,
          },

          c = { require("formatter.defaults").clang_format },
          cpp = { require("formatter.defaults").clang_format },
          objc = { require("formatter.defaults").clang_format },

          python = {
            require("formatter.defaults").isort,
            require("formatter.defaults").black,
          },

          -- Web related files
          javascript = { require("formatter.defaults").prettier },
          typescript = { require("formatter.defaults").prettier },
          javascriptreact = { require("formatter.defaults").prettier },
          typescriptreact = { require("formatter.defaults").prettier },
          html = { require("formatter.defaults").prettier },
          css = { require("formatter.defaults").prettier },
          scss = { require("formatter.defaults").prettier },
          json = { require("formatter.defaults").prettier },
          markdown = { require("formatter.defaults").prettier },

          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      })

      -- *** THE FIX IS HERE ***
      -- We wrap the call in a function to defer it.
      vim.api.nvim_create_user_command("Format", function()
        require("formatter").format()
      end, {})

      -- Apply the same fix to the keymap for consistency
      vim.keymap.set('n', '<leader>gf', '<cmd>Format<cr>', { noremap = true, silent = true, desc = "[G]o [F]ormat Buffer" })

      -- And to the autocommand
      local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_on_save_group,
        pattern = "*",
        callback = function()
          require("formatter").format({ async = true })
        end,
      })
    end,
  },
}
