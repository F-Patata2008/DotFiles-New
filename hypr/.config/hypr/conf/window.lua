-- =============================================================================
-- WINDOW RULES
-- Organized by: Utility, Geometry, Workspaces, and Aesthetics.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 🛠️ SECTION: GLOBAL FLOATING RULES
-- System tools that should always appear above tiling.
-- -----------------------------------------------------------------------------
hl.window_rule({
    name  = "pavucontrol",
    match = { class = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name  = "bluetooth",
    match = { class = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name  = "internet",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name   = "clipboard",
    match  = { class = "^(clipse)$" },
    float  = true,
    center = true,
})

hl.window_rule({
    name  = "Notes",
    match = { class = "^(Notas)$" },
    float = true,
})

hl.window_rule({
    name  = "desktop-portals-float",
    match = {
        class = "^(xdg-desktop-portal-gtk)$",
        title = "^(Open File|Select File|Save File)$",
    },
    float = true,
})

hl.window_rule({
    name   = "Select-Wallpaper",
    match  = { class = "^(Select-Wallpaper)$" },
    float  = true,
    center = true,
    size   = "60% 40%",
    pin    = true,
})

-- -----------------------------------------------------------------------------
-- 📐 SECTION: GEOMETRY & PLACEMENT
-- Define specific sizes and positions for floating windows.
-- -----------------------------------------------------------------------------

-- GTK File Picker portal
hl.window_rule({
    name   = "portal-geometry",
    match  = { class = "^(xdg-desktop-portal-gtk)$" },
    size   = "60% 70%",
    center = true,
})

-- Clipboard manager (Clipse)
hl.window_rule({
    name  = "clipse-geometry",
    match = { class = "^(clipse)$" },
    size  = "622 652",
})

-- Quick Notes app
hl.window_rule({
    name   = "notes-geometry",
    match  = { class = "^(Notas)$" },
    size   = "300 200",
    center = true,
})

-- Browser Picture-in-Picture (fixed position, bottom-right corner)
hl.window_rule({
    name  = "browser-pip-geometry",
    match = { title = "^(Picture in Picture)$" },
    float = true,
    move  = "1081 751",
    size  = "284 160",
    pin   = true,
})

-- -----------------------------------------------------------------------------
-- 🖥️ SECTION: WORKSPACE ASSIGNMENTS
-- Automatically send apps to specific workspaces.
-- -----------------------------------------------------------------------------

-- Workspace 2: Multimedia & Social
hl.window_rule({
    name      = "workspace-social-media",
    match     = { class = "^(spotify|discord)$" },
    workspace = "2 silent",
})

-- Workspace 3: Development / Dotfiles
hl.window_rule({
    name      = "workspace-dotfiles",
    match     = { class = "^(Dotfiles)$" },
    workspace = "3 silent",
})

hl.window_rule({
    name      = "workspace-dotfiles",
    match     = { class = "^(Ai)$" },
    workspace = "3 silent",
})

-- -----------------------------------------------------------------------------
-- ✨ SECTION: VISUAL OVERRIDES
-- App-specific aesthetic tweaks.
-- -----------------------------------------------------------------------------

-- Kitty: force 100% opacity for better code readability
-- opacity is a dynamic effect; "1.0 override" sets it absolutely (not multiplicative)
hl.window_rule({
    name    = "kitty-visuals",
    match   = { class = "^(kitty)$" },
    opacity = "1.0 override",
})

-- Disable blur on video windows to save resources
hl.window_rule({
    name    = "video-no-blur",
    match   = { title = "^(Picture in Picture)$" },
    no_blur = true,
})
