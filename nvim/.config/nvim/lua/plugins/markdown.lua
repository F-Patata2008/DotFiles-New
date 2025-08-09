return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    config = function()
        vim.g.mkdp_auto_start = 0  -- don't start automatically
        vim.g.mkdp_auto_close = 1  -- close preview when buffer closes
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_open_to_the_world = 0
        vim.g.mkdp_browser = ""    -- leave empty to use default browser
    end
}

