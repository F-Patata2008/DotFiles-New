return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.hyprlang = {
        install_info = {
          url = "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "hyprlang",
      }

      require('nvim-treesitter.configs').setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "cpp", "hyprlang", "latex" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      })
    end,
  },
}

