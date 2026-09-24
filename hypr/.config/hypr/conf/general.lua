-- ==============================================================================
-- GENERAL
-- ==============================================================================
local colors_path = os.getenv("HOME") .. "/.cache/noctalia/hyprland-colors.lua"
pcall(dofile, colors_path)

local noctalia = require("noctalia")
local active_border = primary or (noctalia and noctalia.colors and noctalia.colors.primary) or "rgb(e6b450)"
local inactive_border = surface or (noctalia and noctalia.colors and noctalia.colors.surface) or "rgb(0b0e14)"

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 4,
        border_size = 1,

        col = {
            active_border   = active_border,
            inactive_border = inactive_border,
        },

        layout = "dwindle",
    },

    -- ==============================================================================
    -- DWINDLE
    -- ==============================================================================
    dwindle = {
        preserve_split = true,
        -- smart_split = true,
    },

    -- ==============================================================================
    -- MISC
    -- ==============================================================================
    misc = {
        force_default_wallpaper = 0,
    },

    -- ==============================================================================
    -- SCROLLING LAYOUT
    -- ==============================================================================
    scrolling = {
        fullscreen_on_one_column = true,
        column_width             = 0.9,
        direction                = "right",
    },

    master = {
        new_status = "slave",
        mfact      = 0.80,    -- 80% master / 20% stack
        orientation = "left",
    },
})

-- ==============================================================================
-- WORKSPACE RULES
-- ==============================================================================
hl.workspace_rule({ workspace = "3", layout = "master" })
