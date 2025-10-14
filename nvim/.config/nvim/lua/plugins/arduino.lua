-- lua/plugins/arduino.lua
return {
  {
    "yuukiflow/Arduino-Nvim",
    ft = { "ino", "cpp" }, -- Triggers on Arduino and C++ files
    dependencies = {
      "nvim-telescope/telescope.nvim", -- It uses Telescope for pickers
    },
    config = function()
      require("arduino").setup({
        -- You can leave this empty to use the defaults,
        -- or configure it as needed.
        -- For example:
        default_fqbn = "arduino:avr:uno",
        default_port = "/dev/ttyACM0", -- Change this to your board's port
      })
    end,
  }
}
