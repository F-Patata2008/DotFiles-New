return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function(_, opts)
      -- add custom parser
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.hyprlang = {
        install_info = {
          url = "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "hyprlang",
      }

      -- keep/merge your settings
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "c", "lua", "vim", "vimdoc", "cpp", "hyprlang", "latex",
        "markdown", "markdown_inline", "html", "css", "scss", "json",
        "bash", "javascript",
      })

      opts.sync_install = false
      opts.auto_install = true
      opts.highlight = { enable = true }
      opts.indent = { enable = true }
    end,
  },
}
