-- ==============================================================================
-- AUTOSTART
-- ==============================================================================
hl.on("hyprland.start", function()

    -- --------------------------------------------------------------------------
    -- CORE SERVICES (order matters — sequential to avoid race conditions)
    -- --------------------------------------------------------------------------
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- --------------------------------------------------------------------------
    -- SHELL
    -- --------------------------------------------------------------------------
    hl.exec_cmd("wal -R")              -- Restore Pywal colors
    hl.exec_cmd("qs -c noctalia-shell")

    -- --------------------------------------------------------------------------
    -- HARDWARE & SYNC
    -- --------------------------------------------------------------------------
    hl.exec_cmd("udiskie")                                                       -- USB automount
    hl.exec_cmd("solaar --window=hide --battery-icons=symbolic > /dev/null 2>&1")-- Logitech devices
    hl.exec_cmd("kdeconnectd")                                                   -- Backend only (Noctalia has a widget)

    -- --------------------------------------------------------------------------
    -- UTILS
    -- --------------------------------------------------------------------------
    hl.exec_cmd("hypridle")
    hl.exec_cmd("clipse -listen")                                                -- Clipboard manager
    hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")

    -- --------------------------------------------------------------------------
    -- USER APPS
    -- --------------------------------------------------------------------------
    hl.exec_cmd("kitty --class Dotfiles --directory ~/Dotfiles")
    hl.exec_cmd("kitty --class Dotfiles --directory ~/Dotfiles")
    hl.exec_cmd("kitty --class Ai -e 'ollama run miku' ")

end)
