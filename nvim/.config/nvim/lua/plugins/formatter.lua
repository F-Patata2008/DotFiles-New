return {
  "mhartington/formatter.nvim",
  -- Load the plugin when you open a file, which is early enough.
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Your existing setup is correct.
    -- This tells formatter.nvim which tools to use for which files.
    require("formatter").setup({
      logging = false,
      filetype = {
        lua = { require("formatter.defaults").stylua },
        latex = { require("formatter.defaults").latexindent },
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

    -- KEY CHANGE: Use the standard Neovim formatting API.
    -- This is more reliable than calling require("formatter").format() directly.

    -- Autocommand for format on save
    local augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      pattern = "*",
      callback = function()
        vim.lsp.buf.format({ async = true })
      end,
    })

    -- Keymap for manual formatting
    vim.keymap.set({ "n", "v" }, "<leader>gf", function()
      vim.lsp.buf.format()
    end, { desc = "[G]o [F]ormat Buffer" })
  end,
}
