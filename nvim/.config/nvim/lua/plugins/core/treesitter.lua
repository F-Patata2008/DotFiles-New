return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    init = function()
      -- Fix for modern tree-sitter CLI (>= 0.22) where '--no-bindings' was removed
      local ok, install = pcall(require, "nvim-treesitter.install")
      if ok then
        install.ts_generate_args = { "generate", "--abi", tostring(vim.treesitter.language_version) }
      end
    end,
    config = function(_, opts)
      local ok, install = pcall(require, "nvim-treesitter.install")
      if ok then
        install.ts_generate_args = { "generate", "--abi", tostring(vim.treesitter.language_version) }
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
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
        "bash", "javascript", "python", "diff",
      },

      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
