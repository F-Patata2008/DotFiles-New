-- ==============================================================================
-- INPUT
-- ==============================================================================
hl.config({
    input = {
        kb_layout    = "latam",
        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- ==============================================================================
-- GESTURES
-- ==============================================================================
local ipc = "qs -c noctalia-shell ipc call"

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.gesture({
    fingers   = 3,
    direction = "up",
    action    = function()
        hl.exec_cmd(ipc .. " launcher windows")
    end,
})
