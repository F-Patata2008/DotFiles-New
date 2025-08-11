return {
	{
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "github/copilot.vim" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        opts = {},
        config = function()
            require("CopilotChat").setup({})
            vim.keymap.set('n', '<C-c>', ':CopilotChat<CR>', {})
        end
    }
}


