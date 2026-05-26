-- =====================================================
-- Main Hyprland Config
-- =====================================================

-- -----------------------------------------------------
-- COLORS (Noctalia — auto-generated, do not edit)
-- -----------------------------------------------------
local colors = dofile(os.getenv("HOME") .. "/.cache/noctalia/hyprland-colors.lua")

-- -----------------------------------------------------
-- ENVIRONMENT VARIABLES
-- -----------------------------------------------------

-- Wayland session identifiers (required for SDDM)
hl.env("XDG_CURRENT_DESKTOP",                "Hyprland")
hl.env("XDG_SESSION_TYPE",                   "wayland")
hl.env("XDG_SESSION_DESKTOP",                "Hyprland")

-- Qt
hl.env("QT_QPA_PLATFORM",                    "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION","1")

-- GTK / Firefox
hl.env("GDK_BACKEND",                        "wayland,x11,*")
hl.env("MOZ_ENABLE_WAYLAND",                 "1")

-- Scaling — 1 is standard, 1.25 or 1.5 for HiDPI
hl.env("GDK_SCALE",                          "1")

-- -----------------------------------------------------
-- MODULES
-- -----------------------------------------------------
require("conf.startup")
require("conf.input")
require("conf.general")
require("conf.aesthetics")
require("conf.animations")
require("conf.binds")
require("conf.window")
