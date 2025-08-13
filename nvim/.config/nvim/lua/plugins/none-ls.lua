-- plugins/none-ls.lua (or your equivalent file)
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      -- For a list of available sources, see:
      -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
      sources = {
        -- Formatting
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,

        -- Diagnostics (Linters)
        -- To use these, uncomment the lines and install the corresponding tools.
        -- null_ls.builtins.diagnostics.eslint_d,
        -- null_ls.builtins.diagnostics.shellcheck,
        -- null_ls.builtins.diagnostics.luacheck.with({
        --   extra_args = { "--globals", "vim" },
        -- }),
      },
    })
  end,
}
