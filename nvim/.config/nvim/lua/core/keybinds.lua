local map = vim.keymap.set

-- Open Telescope theme chooser with <leader>th
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Choose Theme" })

map('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})

-- Save file with Ctrl + s
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save File" })

-- Select all text with Ctrl + g
-- gg goes to the first line, V enters visual line mode, G goes to the last line
map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- Quit Neovim with Ctrl + q
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })

map('n', '<C-l>', '<Cmd>VimtexCompile<CR>', {
                noremap = true,
                silent = true,
                desc = "Compile LaTeX (Vimtex)"
            })

-- Trouble plugin keymaps
-- Use <cmd>...<CR> for robustness, as it doesn't require the plugin to be loaded beforehand.
map("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble List" })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { desc = "Workspace Diagnostics" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Document Diagnostics" })

map("n", "<leader>mp", "<cmd>RenderMarkdownToggle<CR>", { desc = "Toggle Markdown Render" })


