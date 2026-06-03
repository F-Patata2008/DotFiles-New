-- ==============================================================================
-- VARIABLES
-- ==============================================================================
local mainMod     = "SUPER"
local ipc         = "qs -c noctalia-shell ipc call"
local terminal    = "kitty"
local fileManager = "nautilus"
local browser     = "zen-browser"

-- ==============================================================================
-- NOCTALIA SHELL
-- ==============================================================================
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(ipc .. " launcher toggle"))       -- App Launcher
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(ipc .. " launcher command"))      -- Command Mode
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(ipc .. " launcher emoji"))        -- Emoji Picker
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(ipc .. " controlCenter toggle"))  -- Dashboard
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd(ipc .. " sessionMenu toggle"))    -- Power Menu

-- ==============================================================================
-- APPLICATIONS & UTILITIES
-- ==============================================================================
hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd(terminal))                                              -- Terminal
hl.bind(mainMod .. " + A",         hl.dsp.exec_cmd(terminal .. " --class Ai -e ollama run miku"))        -- Ollama Running Miku
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd(browser))                                               -- Browser
hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd("flatpak run com.spotify.Client"))                      -- Spotify
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(terminal .. " -e yazi"))                                -- CLI File Manager
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd(ipc .. " lockScreen lock"))                             -- Lock Screen
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(fileManager))                                           -- GUI File Manager
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(terminal .. " --class clipse -e 'clipse'"))             -- Clipboard
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(terminal .. " --class Notas -e nvim $HOME/Notas.md"))   -- Notes

-- ==============================================================================
-- HARDWARE — Volume & Brightness
-- ==============================================================================
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(ipc .. " volume increase"),    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(ipc .. " volume decrease"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(ipc .. " volume muteOutput"),  { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(ipc .. " volume muteInput"),   { locked = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(ipc .. " brightness increase"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness decrease"), { locked = true, repeating = true })

-- ==============================================================================
-- MEDIA PLAYERS
-- ==============================================================================
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- ==============================================================================
-- WINDOW MANAGEMENT
-- ==============================================================================
hl.bind(mainMod .. " + C", hl.dsp.window.close())                       -- Close Window
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))  -- Toggle Float
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))                 -- Toggle Split (dwindle)

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ==============================================================================
-- WORKSPACES
-- ==============================================================================

-- Switch + Move to workspaces 1–10
for i = 1, 10 do
    local key = i % 10  -- 10 wraps to key "0"
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))

-- Column layout (only applies when layout = scrolling)
hl.bind(mainMod .. " + period",         hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma",          hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.layout("swapcol l"))

-- ==============================================================================
-- SCREENSHOTS & TOOLS
-- ==============================================================================
hl.bind("PRINT",                   hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh"))
hl.bind("SHIFT + PRINT",           hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/Screenshots"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
