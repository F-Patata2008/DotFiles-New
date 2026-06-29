return {
    {
      "mhartington/formatter.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        require("formatter").setup({
          logging = true,  -- Cambia a true temporalmente para debug
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
            -- ... resto del config igual
            python = {
              require("formatter.defaults").isort,
              require("formatter.defaults").black,
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
          pattern = "*.cpp,*.c,*.h",  -- Sé específico aquí
          command = "Format",
        })
      end,
    },
}
