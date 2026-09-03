return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = (vim.fn.executable("make") == 1 and os.getenv("TERMUX_VERSION") == nil) and "make install_jsregexp" or nil,
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            -- Load custom snippets from lua/snippets
            require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/lua/snippets"
            })

            -- Load vscode-style friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require("luasnip")
            ls.filetype_extend("plaintex", { "tex" })
            ls.filetype_extend("latex", { "tex" })
        end,
    }
}

