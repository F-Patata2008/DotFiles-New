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
              function()
                if vim.fn.executable("ruff") == 1 then
                  return {
                    exe = "ruff",
                    args = { "format", "--stdin-filename", vim.api.nvim_buf_get_name(0), "-" },
                    stdin = true,
                  }
                elseif vim.fn.executable("black") == 1 then
                  return {
                    exe = "black",
                    args = { "-" },
                    stdin = true,
                  }
                end
              end,
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
          pattern = "*.cpp,*.c,*.h,*.md,*.py",
          command = "Format",
        })
      end,
    },
}
