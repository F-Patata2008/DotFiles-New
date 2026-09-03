local map = vim.keymap.set

-- Telescope keymaps
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Choose Theme" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })

map('n', '<C-n>', ':Neotree filesystem reveal left<CR>', { desc = "Toggle Neo-tree" })

-- Save file with Ctrl + s
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save File" })

-- Select all text with Ctrl + a
map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- Quit Neovim with Ctrl + q
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })

map('n', '<C-l>', '<Cmd>VimtexCompile<CR>', {
    noremap = true,
    silent = true,
    desc = "Compile LaTeX (Vimtex)"
})

-- Trouble v3 keymaps
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP Defs/Refs (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

-- Molten (Jupyter interactive execution)
map("n", "<leader>mi", "<cmd>MoltenInit<CR>", { desc = "Molten: Initialize Kernel" })
map("n", "<leader>me", "<cmd>MoltenEvaluateOperator<CR>", { desc = "Molten: Evaluate Operator" })
map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<CR>", { desc = "Molten: Evaluate Line" })
map("n", "<leader>mr", "<cmd>MoltenReevaluateCell<CR>", { desc = "Molten: Re-evaluate Cell" })
map("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten: Evaluate Visual", silent = true })
map("n", "<leader>mh", "<cmd>MoltenHideOutput<CR>", { desc = "Molten: Hide Output" })
map("n", "<leader>md", "<cmd>MoltenDelete<CR>", { desc = "Molten: Delete Cell Output" })

map("n", "<leader>mp", "<cmd>RenderMarkdownToggle<CR>", { desc = "Toggle Markdown Render" })

map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment" })
