return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup({}) -- Use default Telescope settings
      -- Load the themes extension
      telescope.load_extension('themes')
    end
  },
  {
    -- This is the plugin that provides the theme chooser
    'andrewberty/telescope-themes',
    dependencies = { 'nvim-telescope/telescope.nvim' }
  }
}
