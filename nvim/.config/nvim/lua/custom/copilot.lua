return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- disable ghost text inline
        panel = { enabled = false },      -- disable side panel
        filetypes = { ["*"] = true },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = "copilot.lua",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },  -- use copilot.lua as backend
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({})
      vim.keymap.set("n", "<C-c>", ":CopilotChat<CR>", { noremap = true, silent = true })
    end,
  },
}

