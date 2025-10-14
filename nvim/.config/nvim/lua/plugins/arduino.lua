-- lua/plugins/arduino.lua
return {
  {
    "yuukiflow/Arduino-Nvim",
    ft = { "ino" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("Arduino-Nvim.lsp").setup()

      require("Arduino-Nvim").setup({
        default_fqbn = "arduino:avr:uno",
        -- default_port = "/dev/ttyUSB0",
      })
    end,
  }
}
