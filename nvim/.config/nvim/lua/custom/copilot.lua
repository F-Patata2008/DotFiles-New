
return {
    --[[
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
    config = function()
        require("CopilotChat").setup({
            debug = true,
            })
        vim.keymap.set('n', '<C-c>', ':CopilotChat<CR>', {})
    end
	}, 
    ]]
}


