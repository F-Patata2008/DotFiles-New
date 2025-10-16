return {
  "yuukiflow/Arduino-Nvim",
  ft = "arduino",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("Arduino-Nvim.lsp").setup()
    require("Arduino-Nvim").setup()
  end,
}
