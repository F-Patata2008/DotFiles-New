-- ==============================================================================
-- MONITORS
-- ==============================================================================

-- Built-in Laptop Display (Lenovo E41-55: 1366x768 @ 60Hz)
hl.monitor({
    output   = "eDP-1",
    mode     = "1366x768@60",
    position = "0x0",
    scale    = 1,
})

-- External 1080p Display connected to the LEFT (HDMI-A-1: 1920x1080 @ 60Hz)
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "auto-left",
    scale    = 1,
})

-- Generic Fallback for any hotplugged external display
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto-left",
    scale    = 1,
})
