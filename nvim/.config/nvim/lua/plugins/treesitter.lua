return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- This command is used to update parsers.
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or "all"
        -- We'll start with C, Lua, and Vim script parsers.
        ensure_installed = { "c", "lua", "vim", "vimdoc", "cpp", "latex" },

        -- Install parsers synchronously (useful for headless servers)
        sync_install = false,

        -- Automatically install missing parsers when entering a buffer
        auto_install = true,

        -- Enable the highlight module for syntax highlighting
        highlight = {
          enable = true,
        },
        indent = {enable = true}
      })
    end,
  },
}
