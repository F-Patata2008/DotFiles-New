return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
      telescope.setup({}) -- Use default Telescope settings
      -- Load the themes extension
      telescope.load_extension('themes')
    end
  },
  {
    -- This is the plugin that provides the theme chooser
    'andrewberty/telescope-themes',
    dependencies = { 'nvim-telescope/telescope.nvim' }
  },
    {
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup {
  			extensions = {
    				["ui-select"] = {
				      require("telescope.themes").get_dropdown {}
    					}
	  			}
			}
			require("telescope").load_extension("ui-select")
		end
	}
}
