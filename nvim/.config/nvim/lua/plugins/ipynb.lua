return {
  -- For transparently editing ipynb files as text
  {
    "goerz/jupytext.nvim",
    -- Load it on ipynb files
    ft = { "ipynb" },
    -- You can also use :Jupytext toggle to start editing a .py file
    -- as a notebook.
  },

  -- For running cells and interacting with the kernel
  {
    "benlubas/molten-nvim",
    -- This is a dependency for the UI
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Load molten on jupytext buffers
    ft = { "python", "ipynb" },
    config = function()
      require("molten").setup({
        -- Where to place the output window
        output_panel = {
          position = "bottom",
        },
        -- Automatically open the output panel when running code
        auto_open_output = true,
      })

      -- Keymaps
      local map = vim.keymap.set
      -- Initialize the kernel. You must run this first.
      map("n", "<leader>mi", "<cmd>MoltenInit<cr>", { desc = "[M]olten [I]nit" })
      -- Run the current cell
      map("n", "<leader>mr", "<cmd>MoltenRunCell<cr>", { desc = "[M]olten [R]un Cell" })
      -- Run the line under the cursor
      map("n", "<leader>ml", "<cmd>MoltenRunLine<cr>", { desc = "[M]olten [L]ine" })
      -- Run a visual selection
      map("v", "<leader>mr", "<cmd>MoltenRunVisual<cr>", { desc = "[M]olten [R]un Visual" })
    end,
  },
}
