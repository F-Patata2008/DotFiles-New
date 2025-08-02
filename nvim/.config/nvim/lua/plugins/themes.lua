return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true,
                term_colors = true,
                styles = {
                    comments = { "italic" },
                    functions = { "italic" },
                    keywords = { "italic" },
                    variables = { "italic" },
                },
                integrations = {
                    treesitter = true,
                    telescope = true,
                    gitsigns = true,
                    lsp_trouble = true,
                    cmp = true,
                    which_key = true,
                    dashboard = true,
                    neotree = true,
                },
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
}
