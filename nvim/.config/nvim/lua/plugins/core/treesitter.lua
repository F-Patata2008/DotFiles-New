return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- custom parser (new-style)
      parser_config = {
        hyprlang = {
          install_info = {
            url = "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang",
            files = { "src/parser.c" },
            branch = "main",
          },
          filetype = "hyprlang",
        },
      },

      ensure_installed = {
        "c", "lua", "vim", "vimdoc", "cpp", "hyprlang", "latex",
        "markdown", "markdown_inline", "html", "css", "scss", "json",
        "bash", "javascript",
      },

      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
