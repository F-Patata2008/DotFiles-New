return {
    {
        "edKotinsky/nvim-arduino",
        cmd = { "Arduino" },
        ft = { "ino" },
        config = function()
            require("arduino").setup({
                cli_bin = "arduino-cli", -- or the path to your arduino-cli binary
                default_fqbn = "arduino:avr:uno", -- change this to your default board
                -- other options...
            })
        end,
    }
}
