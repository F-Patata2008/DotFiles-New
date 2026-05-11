return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            -- Cargar snippets desde lua/custom/snippets
            require("luasnip.loaders.from_lua").lazy_load({
                paths = vim.fn.stdpath("config") .. "/lua/snippets"
            })

            -- También cargar snippets tipo vscode friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require("luasnip")
            ls.filetype_extend("plaintex", { "tex" })
            ls.filetype_extend("latex", { "tex" })
        end,
    }
}

