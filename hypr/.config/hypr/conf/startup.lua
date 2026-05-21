-- ==============================================================================
-- AUTOSTART
-- ==============================================================================

hl.on("hyprland.start", function()

    -- --- CORE SERVICES (Order Matters) ---
    -- Update DBUS, import environment, and start the session target sequentially to avoid race conditions
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- --- THE SHELL (Noctalia/AGS) ---
    hl.exec_cmd("wal -R")           -- Restore Pywal colors
    hl.exec_cmd("qs -c noctalia-shell")

    -- --- PERFORMANCE HACKS ---
    -- This makes Thunar open INSTANTLY when you call it
    hl.exec_cmd("thunar --daemon")

    -- --- HARDWARE & SYNC ---
    hl.exec_cmd("udiskie")                                                      -- USB Automount
    hl.exec_cmd("solaar --window=hide --battery-icons=symbolic > /dev/null 2>&1") -- Logitech devices
    hl.exec_cmd("kdeconnectd")                                                  -- Backend only (Noctalia has a widget)

    -- --- UTILS ---
    hl.exec_cmd("hypridle")
    hl.exec_cmd("clipse -listen")                                               -- Clipboard manager
    hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")

    -- --- USER APPS ---
    hl.exec_cmd("kitty --class Dotfiles --directory ~/Dotfiles")

end)
