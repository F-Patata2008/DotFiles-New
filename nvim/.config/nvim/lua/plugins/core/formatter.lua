return {
    {
      "mhartington/formatter.nvim",
      -- Load the plugin when you open or create a file.
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        -- This setup function runs and registers the :Format command.
        require("formatter").setup({
          logging = false,
          filetype = {
            tex = { require("formatter.defaults").latexindent },
            lua = { require("formatter.defaults").stylua },
            c = { require("formatter.defaults").clang_format },
            cpp = { require("formatter.defaults").clang_format },
            objc = { require("formatter.defaults").clang_format },
            python = {
              require("formatter.defaults").isort,
              require("formatter.defaults").black,
            },
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

        -- KEY CHANGE: Use the command, not the Lua function.
        -- This is the stable way to call the formatter.
        vim.keymap.set({ "n", "v" }, "<leader>gf", "<cmd>Format<cr>", { desc = "[G]o [F]ormat Buffer" })

        -- Use the plugin's recommended command for format-on-save.
        local augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          pattern = "*",
          -- The :Format command will now work reliably here as well.
          command = "Format",
        })
      end,
    },
}
