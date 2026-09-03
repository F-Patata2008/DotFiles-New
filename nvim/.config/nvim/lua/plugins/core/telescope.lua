return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'andrewberty/telescope-themes',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      })
      pcall(telescope.load_extension, 'themes')
      pcall(telescope.load_extension, 'ui-select')
    end,
  },
}
