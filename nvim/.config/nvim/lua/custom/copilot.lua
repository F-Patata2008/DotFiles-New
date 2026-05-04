return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        allow_insecure = false,
        proxy = nil,
        system_prompt = "You are an AI assistant that helps with coding.",
        model = "gpt-5.2",
        temperature = 0.1,
        agent = "copilot",
      })

      vim.keymap.set("n", "<leader>cc", ":CopilotChat<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ce", ":CopilotChatExplain<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>cr", ":CopilotChatReview<CR>", { noremap = true, silent = true })
    end,
  },
}
