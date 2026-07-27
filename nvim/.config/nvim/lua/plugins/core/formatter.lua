return {
    {
      "mhartington/formatter.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("formatter").setup({
          logging = true,
          filetype = {
            tex = { require("formatter.defaults").latexindent },
            lua = { require("formatter.defaults").stylua },
            c = {
              function()
                return {
                  exe = "clang-format",
                  stdin = true,
                }
              end,
            },
            cpp = {
              function()
                return {
                  exe = "clang-format",
                  stdin = true,
                }
              end,
            },
            objc = {
              function()
                return {
                  exe = "clang-format",
                  stdin = true,
                }
              end,
            },
            python = {
              require("formatter.defaults").isort,
              require("formatter.defaults").black,
            },
            markdown = {
              function()
                return {
                  exe = "prettier",
                  args = { "--parser", "markdown" },
                  stdin = true,
                }
              end,
            },
            ["*"] = {
              require("formatter.filetypes.any").remove_trailing_whitespace,
            },
          },
        })
        vim.keymap.set({ "n", "v" }, "<leader>gf", "<cmd>Format<cr>", { desc = "[G]o [F]ormat Buffer" })
        local augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          pattern = "*.cpp,*.c,*.h,*.md",
          command = "Format",
        })
      end,
    },
}
