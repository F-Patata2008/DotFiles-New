return {
  {
    "anuvyklack/ipynb.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- lazy-load on .ipynb files
    ft = "ipynb",
    config = function()
      require("ipynb").setup({
        kernel = {
          display = {
            image = {
              -- Use the kitty backend for native image support in Kitty
              backend = "kitty",
            },
          },
        },
      })

      -- Add some useful keymaps
      local map = vim.keymap.set
      map("n", "<leader>kc", "<cmd>IPythonCellRun<cr>", { desc = "[K]ernel [C]ell Run" })
      map("n", "<leader>ka", "<cmd>IPythonCellRunAll<cr>", { desc = "[K]ernel [A]ll Cells Run" })
      map("n", "<leader>kd", "<cmd>IPythonCellDelete<cr>", { desc = "[K]ernel [D]elete Cell" })
      map("n", "<leader>ki", "<cmd>IPythonInterrupt<cr>", { desc = "[K]ernel [I]nterrupt" })
      map("n", "<leader>kr", "<cmd>IPythonRestart<cr>", { desc = "[K]ernel [R]estart" })
    end,
  },
}
