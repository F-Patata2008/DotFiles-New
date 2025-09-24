-- Tu archivo de configuración de vimtex
return { 
    {
        "lervag/vimtex",
        ft = { "tex", "latex", "bib" },
        init = function()
            vim.g.vimtex_compiler_method = "latexmk"
            -- vim.g.vimtex_compiler_latexmk = { pdflatex = 'lualatex -interaction=nonstopmode %O %S' }

            vim.g.vimtex_view_zathura = {
                wayland = 1,
                nvim_instance = vim.v.servername,
            }

            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_spell_enabled = 1
        end,

        config = function()
            local map = vim.keymap.set
            local opts = { silent = true, noremap = true }
        end,
    }
}
