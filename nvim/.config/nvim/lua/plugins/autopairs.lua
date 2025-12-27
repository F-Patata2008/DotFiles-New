return {
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- Will use default configuration
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    }
}
