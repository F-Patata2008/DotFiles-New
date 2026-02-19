==================================================================
 DUMP DE CONFIGURACIÓN: hypr/.config/hypr
 Fecha: Wed Feb 18 11:51:28 PM -03 2026
==================================================================


################################################################################
ARCHIVO: hypr/.config/hypr/conf/aesthetics.conf
################################################################################

# Aesthetics
source = ~/.cache/wal/colors-hyprland.conf

# Specific rule for Noctalia's background and widgets
layerrule {
    name = noctalia
    match:namespace = noctalia-.*$  # Optimized regex for all Noctalia components
    blur = true
    blur_popups = true
    ignore_alpha = 0.5
}

decoration {
    rounding = 12 # Middle ground: 5 is too blocky, 20 is too much
    # rounding_power = 2 # Optional: creates "squarcles" (smooth corners)

    blur {
        enabled = true
        size = 3
        passes = 1 # CRITICAL: 2 passes doubles the work for your GPU. 1 pass + noise looks great.

        vibrancy = 0.1696
        ignore_opacity = true
        new_optimizations = true # Crucial for performance
        xray = true # Saves battery/CPU by not blurring windows under the active one
    }

    shadow {
        enabled = false # Performance over looks for the Ryzen 3
    }
}

################################################################################
ARCHIVO: hypr/.config/hypr/conf/animations.conf
################################################################################

# Animations
animations {
    enabled = yes

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

################################################################################
ARCHIVO: hypr/.config/hypr/conf/binds.conf
################################################################################

# --- Variables ---
$mainMod = SUPER
$ipc = qs -c noctalia-shell ipc call
$terminal = kitty
$fileManager = thunar
$browser = zen-browser

# --- Core Noctalia Binds (The "Connected" UI) ---
bind = $mainMod, R, exec, $ipc launcher toggle          # App Launcher
bind = $mainMod, Q, exec, $ipc launcher command         # Command Launcher
bind = $mainMod SHIFT, S, exec, $ipc controlCenter toggle     # The "Mundo Hola" Dashboard
bind = $mainMod, comma, exec, $ipc settings toggle      # Shell Settings
bind = $mainMod SHIFT, L, exec, $ipc sessionMenu toggle # Power Menu
bind = $mainMod SHIFT, R, exec, $ipc launcher emoji      # Emoji Picker

# --- Application Binds ---
bind = $mainMod, T, exec, $terminal
bind = $mainMod, B, exec, $browser
bind = $mainMod, S, exec, spotify
bind = $mainMod, C, killactive,
bind = $mainMod, J, togglesplit,
bind = $mainMod, V, togglefloating,
bind = $mainMod, F, fullscreen, 1

# --- THE SPEED BIND (Objective 2) ---
# Use Yazi for "Instant" file browsing, Thunar for GUI tasks
bind = $mainMod, E, exec, $terminal -e yazi
bind = $mainMod SHIFT, E, exec, $fileManager

# --- System & Hardware (Using Noctalia IPC for OSD) ---
bindel = , XF86AudioRaiseVolume, exec, $ipc volume increase
bindel = , XF86AudioLowerVolume, exec, $ipc volume decrease
bindl  = , XF86AudioMute, exec, $ipc volume muteOutput
bindl  = , XF86AudioMicMute, exec, $ipc volume muteInput
bindel = , XF86MonBrightnessUp, exec, $ipc brightness increase
bindel = , XF86MonBrightnessDown, exec, $ipc brightness decrease

# --- Player Controls ---
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous

# --- Utilities ---
bind = $mainMod, L, exec, pidof hyprlock || hyprlock
bind = $mainMod SHIFT, P, exec, hyprpicker -a
bind = $mainMod SHIFT, V, exec, kitty --class clipse -e 'clipse'
bind = $mainMod SHIFT, N, exec, kitty --class Notas -e nvim $HOME/Notas.md

# --- Screenshot ---
bind = , PRINT, exec, ~/.config/hypr/scripts/screenshot.sh
bind = SHIFT, PRINT, exec, hyprshot -m window -o ~/Pictures/Screenshots

# --- Window Management ---
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# --- Workspaces ---
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Mouse Scroll Workspace
bind = $mainMod, mouse_down, workspace, e-1
bind = $mainMod, mouse_up, workspace, e+1
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

################################################################################
ARCHIVO: hypr/.config/hypr/conf/general.conf
################################################################################

# General
general {
    gaps_in = 2
    gaps_out = 4
    border_size = 1

    col.active_border = $color4
    col.inactive_border = $color0

    layout = dwindle
}

dwindle {
    pseudotile = yes
    preserve_split = yes
    #smart_split = true
}

misc {
    vfr = true
    force_default_wallpaper = 0
}

################################################################################
ARCHIVO: hypr/.config/hypr/conf/input.conf
################################################################################

# Input
input {
    kb_layout = latam
    follow_mouse = 1

    touchpad {
        natural_scroll = yes
    }

    sensitivity = 0
}

gesture = 3, horizontal, workspace

################################################################################
ARCHIVO: hypr/.config/hypr/conf/plugins.conf
################################################################################

# Plugins
#plugin {
#    hyprexpo {
#        rows = 1
#        cols = 0
#        workspace_method = center
#        gap_size = 8
#        bg_col = rgba(10, 10, 10, 0.8)
#    }
#}

################################################################################
ARCHIVO: hypr/.config/hypr/conf/startup.conf
################################################################################

# --- CORE SERVICES (Order Matters) ---
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
exec-once = systemctl --user start hyprland-session.target
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

# --- THE SHELL (Noctalia/AGS) ---
exec-once = wal -R          # Restore Pywal colors
exec-once = ags &           # Launch Noctalia (replaces waybar, swaync, swayosd, wlsunset)

# --- PERFORMANCE HACKS ---
# This makes Thunar open INSTANTLY when you call it
exec-once = thunar --daemon 

# --- HARDWARE & SYNC ---
exec-once = udiskie &       # USB Automount
exec-once = solaar --window=hide --battery-icons=symbolic > /dev/null 2>&1 &
exec-once = kdeconnectd     # Backend only (Noctalia has a widget for this)

# --- UTILS ---
exec-once = hypridle &
exec-once = clipse -listen  # Clipboard manager
exec-once = gnome-keyring-daemon --start --components=pkcs11,secrets,ssh

# --- USER APPS ---
# Only start what you actually need immediately
exec-once = [workspace 1 silent] kitty --class "Dotfiles" --directory ~/Dotfiles

################################################################################
ARCHIVO: hypr/.config/hypr/conf/window.conf
################################################################################

# =============================================================================
# HYPRLAND WINDOW RULES (v0.53+ BLOCK SYNTAX)
# Organizado por: Utilidad, Geometría, Workspaces y Estética.
# =============================================================================

# -----------------------------------------------------------------------------
# 🛠️ SECTION: GLOBAL FLOATING RULES
# Herramientas del sistema que siempre deben aparecer sobre el tiling.
# -----------------------------------------------------------------------------

windowrule {
    name = pavucontrol
    match:class = ^(pavucontrol)$
    float = on
}

windowrule {
    name = bluetooth
    match:class = ^(blueman-manager)$
    float = on
}

windowrule {
    name = internet
    match:class = ^(nm-connection-editor)$
    float = on
}

windowrule {
    name = clipboard
    match:class = ^(clipse)$
    float = on
    center = on
}

windowrule {
    name = Notes
    match:class = ^(Notas)$
    float = on
}

windowrule {
    name = desktop-portals-float
    match:class = ^(xdg-desktop-portal-gtk)$
    match:title = ^(Open File|Select File|Save File)$
    float = on
}

windowrule {
    name = Select-Wallpaper
    match:class = ^(Select-Wallpaper)$
    float = on
    center = on
    size = 60% 40%
    pin = on
}

# -----------------------------------------------------------------------------
# 📐 SECTION: GEOMETRY & PLACEMENT
# Define tamaños específicos y posiciones para ventanas flotantes.
# -----------------------------------------------------------------------------

# Configuración para el Selector de Archivos (GTK Portal)
windowrule {
    name = portal-geometry
    match:class = ^(xdg-desktop-portal-gtk)$
    size = 60% 70%
    center = on
}

# Gestor de Portapapeles (Clipse)
windowrule {
    name = clipse-geometry
    match:class = ^(clipse)$
    size = 622 652
}

# Aplicación de Notas Rápidas
windowrule {
    name = notes-geometry
    match:class = ^(Notas)$
    size = 300 200
    center = on
}

# Navegador Picture-in-Picture (Posición fija en esquina inferior derecha)
windowrule {
    name = browser-pip-geometry
    match:title = ^(Picture in Picture)$
    float = on
    move = 1081 751
    size = 284 160
    pin = on
}

# -----------------------------------------------------------------------------
# 🖥️ SECTION: WORKSPACE ASSIGNMENTS
# Envía aplicaciones a escritorios específicos de forma automática.
# -----------------------------------------------------------------------------

# Workspace 2: Multimedia y Social
windowrule {
    name = workspace-social-media
    match:class = ^(spotify|discord)$
    workspace = 2 silent
}

# Workspace 3: Desarrollo / Archivos de Configuración
windowrule {
    name = workspace-dotfiles
    match:class = ^(Dotfiles)$
    workspace = 3 silent
}

# -----------------------------------------------------------------------------
# ✨ SECTION: VISUAL OVERRIDES
# Ajustes estéticos específicos por aplicación.
# -----------------------------------------------------------------------------

# Kitty: Mantener 100% opaco para mejor legibilidad de código
windowrule {
    name = kitty-visuals
    match:class = ^(kitty)$
    opaque = on
}

# Desactivar blur en apps de video para ahorrar recursos (opcional)
windowrule {
    name = video-no-blur
    match:title = ^(Picture in Picture)$
    no_blur = on
}

################################################################################
ARCHIVO: hypr/.config/hypr/hypridle.conf
################################################################################

# ===================================================================
# HYPRIDLE CONFIGURATION (OPTIMIZED FOR BATTERY LIFE)
#
# This config will:
# 1. Dim the screen after 5 minutes.
# 2. Lock the screen after 10 minutes.
# 3. Suspend-then-hibernate after 15 minutes.
# ===================================================================

general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = pidof hyprlock || hyprlock
    after_sleep_cmd = hyprctl dispatch dpms on
}

# Listener 1: Dim after 3 minutes
listener {
    timeout = 180
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}

# Listener 2: Lock after 5 minutes
listener {
    timeout = 300
    on-timeout = pidof hyprlock || hyprlock
}

# Listener 3: Suspend-then-hibernate after 15 minutes
listener {
    timeout = 900
    # CHANGE THIS LINE
    on-timeout = systemctl suspend-then-hibernate   # Use the new battery-saving action
    on-resume = hyprctl dispatch dpms on
}

################################################################################
ARCHIVO: hypr/.config/hypr/hyprland.conf
################################################################################

# -----------------------------------------------------
# Main Hyprland Config
# -----------------------------------------------------

# --- Environment Variables ---
# (You might have these in a separate file like scripts/env.sh, 
# but if they are here, leave them at the top)
# env = HYPRCURSOR_THEME,Sweet-cursors
# env = HYPRCURSOR_SIZE,20
# ...etc

# Variables para que Hyprland arranque bien desde SDDM
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_QPA_PLATFORM,wayland;xcb
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

# --- THE FIX: Source Theme and Colors FIRST ---
# This line MUST come before any file that uses color variables.
source = ~/.cache/wal/colors-hyprland.conf

# --- Source Monitor and Workspace Configs ---
# Monitor config generated by nwg-displays
source = ~/.config/hypr/monitors.conf

# Workspace rules
source = ~/.config/hypr/workspaces.conf

# --- Source All Configuration Files in 'conf/' ---
source = ~/.config/hypr/conf/startup.conf
source = ~/.config/hypr/conf/input.conf
source = ~/.config/hypr/conf/general.conf
source = ~/.config/hypr/conf/aesthetics.conf
source = ~/.config/hypr/conf/animations.conf
source = ~/.config/hypr/conf/binds.conf
source = ~/.config/hypr/conf/window.conf
source = ~/.config/hypr/conf/plugins.conf # You created a plugins.conf, let's add it!

source = /home/F-Patata/.config/hypr/noctalia/noctalia-colors.conf


################################################################################
ARCHIVO: hypr/.config/hypr/hyprlock.conf
################################################################################

# ===================================================================
# HYPRLOCK CONFIGURATION (Modern & Centered)
# ===================================================================

# --- VARIABLES ---
$font = JetBrainsMono Nerd Font
$text_color = rgba(255, 255, 255, 1.0)
$entry_background = rgba(0, 0, 0, 0.3)
$entry_border = rgba(33ccffee) rgba(00ff99ee) 45deg
$fail_color = rgba(ff6633ee) rgba(ff0066ee) 40deg

# -------------------------------------------------------------------
# GENERAL
# -------------------------------------------------------------------
general {
    hide_cursor = true
    no_fade_in = false
    grace = 0
    disable_loading_bar = true
}

# -------------------------------------------------------------------
# BACKGROUND
# -------------------------------------------------------------------
background {
    monitor =
    # Fixed the double slash '//' in your previous path
    path = $HOME/Dotfiles/Wallpapers/Gundam/33.jpg
    color = rgba(25, 20, 20, 1.0)

    # Enable blur for a "frosted glass" look (premium feel)
    blur_passes = 2
    blur_size = 7
    noise = 0.0117
    contrast = 0.8916
    brightness = 0.8172
    vibrancy = 0.1696
    vibrancy_darkness = 0.0
}

# -------------------------------------------------------------------
# TIME (Big & Centered)
# -------------------------------------------------------------------
label {
    monitor =
    text = cmd[update:1000] echo "$(date +"%H:%M")"
    color = $text_color
    font_size = 120
    font_family = $font ExtraBold
    position = 0, 100
    halign = center
    valign = center
}

# -------------------------------------------------------------------
# DATE
# -------------------------------------------------------------------
label {
    monitor =
    text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
    color = $text_color
    font_size = 20
    font_family = $font
    position = 0, 20
    halign = center
    valign = center
}

# -------------------------------------------------------------------
# "Mundo Hola" LABEL
# -------------------------------------------------------------------
label {
    monitor =
    text = Mundo Hola
    color = rgba(200, 200, 200, 1.0)
    font_size = 14
    font_family = $font Italic
    position = 0, -80
    halign = center
    valign = center
}

# -------------------------------------------------------------------
# INPUT FIELD
# -------------------------------------------------------------------
input-field {
    monitor =
    size = 300, 60
    outline_thickness = 2
    dots_size = 0.2
    dots_spacing = 0.2
    dots_center = true
    outer_color = $entry_border
    inner_color = $entry_background
    font_color = $text_color
    fade_on_empty = false

    # Modern placeholder with icon
    placeholder_text = <i>󰌾  Password...</i>

    hide_input = false
    check_color = $entry_border
    fail_color = $fail_color
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
    capslock_color = rgb(255, 204, 0)

    position = 0, -150
    halign = center
    valign = center
}

# -------------------------------------------------------------------
# FINGERPRINT HINT
# -------------------------------------------------------------------
label {
    monitor =
    text = 󰍂  Scan Fingerprint
    color = rgba(150, 150, 150, 0.8)
    font_size = 12
    font_family = $font
    position = 0, -210
    halign = center
    valign = center
}

################################################################################
ARCHIVO: hypr/.config/hypr/hyprpaper.conf
################################################################################

wallpaper {
    monitor = eDP-1
    path = /home/F-Patata/Dotfiles/Wallpapers/Miku/Miku05.jpg
}

################################################################################
ARCHIVO: hypr/.config/hypr/hyprsunset.conf
################################################################################

max-gamma = 150

# This profile resets the color temperature at 7:00 AM
profile {
    time = 07:00
    identity = true
}

# This profile applies a warm color temperature at 7:00 PM (19:00)
profile {
    time = 21:00
    temperature = 3600
    gamma = 0.8
}

################################################################################
ARCHIVO: hypr/.config/hypr/hyprtoolkit.conf
################################################################################

background = rgba(131316ff)
base = rgba(131316ff)
text = rgba(e4e1e6ff)
alternate_base = rgba(45464fff)
bright_text = rgba(2b3042ff)
accent = rgba(b6c4ffff)
accent_secondary = rgba(c2c5ddff)
################################################################################
ARCHIVO: hypr/.config/hypr/monitors.conf
################################################################################

# Generated by nwg-displays on 2025-09-16 at 22:22:45. Do not edit manually.

monitor=eDP-1,1366x768@60.0,0x144,1.0
monitor=HDMI-A-1,1920x1080@60.0,1366x0,1.0

################################################################################
ARCHIVO: hypr/.config/hypr/noctalia/noctalia-colors.conf
################################################################################

$primary = rgb(b6c4ff)
$surface = rgb(131316)
$secondary = rgb(c2c5dd)
$error = rgb(ffb4ab)
$tertiary = rgb(e3bada)
$surface_lowest = rgb(0e0e11)

general {
    col.active_border = $primary
    col.inactive_border = $surface
}

group {
    col.border_active = $secondary
    col.border_inactive = $surface
    col.border_locked_active = $error
    col.border_locked_inactive = $surface

    groupbar {
        col.active = $secondary
        col.inactive = $surface
        col.locked_active = $error
        col.locked_inactive = $surface
    }
}

################################################################################
ARCHIVO: hypr/.config/hypr/README.md
################################################################################

# 🚀 Configuración de Hyprland

![Hyprland](https://img.shields.io/badge/WM-Hyprland-E54B83?style=for-the-badge&logo=hyperspace&logoColor=white)
![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Pywal](https://img.shields.io/badge/Theme-Pywal-D8A657?style=for-the-badge&logo=linux&logoColor=white)
![Waybar](https://img.shields.io/badge/Bar-Waybar-2E3440?style=for-the-badge&logo=linux-containers&logoColor=white)

Esta es mi configuración personal de Hyprland, diseñada para un flujo de trabajo rápido, eficiente y visualmente cohesivo en Arch Linux. Todo el sistema, desde la terminal hasta Spotify, se adapta dinámicamente al fondo de pantalla.

## ✨ Filosofía
- **Cohesión Dinámica:** El sistema completo está gobernado por **Pywal**. Un solo script (`set_wallpaper.sh`) se encarga de re-tematizar Hyprland, Waybar, Rofi, Kitty, SwayNC, GTK apps y Spicetify.
- **Modularidad y Legibilidad:** La configuración está dividida en archivos lógicos (`binds.conf`, `window.conf`, etc.) y utiliza la sintaxis de bloques de Hyprland 0.40+ para mayor claridad.
- **Eficiencia y Rendimiento:** Se prioriza la ligereza y la funcionalidad del teclado, pero sin sacrificar la estética moderna de Wayland (blur, animaciones, bordes redondeados).

## 📂 Estructura de la Configuración

La configuración está organizada para ser fácilmente mantenible y portable.

```
.
├── hyprland.conf      # Archivo maestro que importa todos los módulos.
├── conf/              # Directorio con los módulos de configuración.
│   ├── aesthetics.conf  # Reglas de blur, bordes y efectos visuales (`layerrule`).
│   ├── animations.conf  # Animaciones de ventanas y workspaces.
│   ├── binds.conf       # Atajos de teclado y mouse.
│   ├── general.conf     # Opciones generales del WM (layout, gaps, etc.).
│   ├── input.conf       # Configs de teclado, mouse y touchpad.
│   └── window.conf      # Reglas de ventana (flotantes, workspaces, tamaño).
├── scripts/           # Corazón de la automatización del setup.
│   ├── set_wallpaper.sh   # Orquesta el cambio de tema en todo el sistema.
│   ├── wallpaper-selector.sh # Selector de wallpapers con vista previa en Kitty+FZF.
│   └── capture-menu.sh  # Menú unificado para screenshots y grabación de pantalla.
├── hyprlock.conf      # Tema de la pantalla de bloqueo.
├── hypridle.conf      # Reglas de inactividad (suspensión, hibernación).
└── monitors.conf      # Configuración de monitores.
```

## 🌟 Características Destacadas

- **Selector de Wallpapers con Vista Previa en Terminal:** Un script personalizado (`wallpaper-selector.sh`) utiliza `fzf` y `kitty +kitten icat` para crear una galería de wallpapers con previsualización en vivo, sin salir de la terminal.
- **Theming de Espectro Completo:**
  - **GTK3/4 & Libadwaita:** El script `set_wallpaper.sh` no solo genera un tema con `oomox`, sino que también aplica `gsettings` y crea symlinks para forzar el theming en aplicaciones de GNOME y Flatpaks.
  - **Spotify:** Se integra con `spicetify` para que la aplicación de Spotify también adopte la paleta de colores del wallpaper.
- **Centro de Captura Unificado:** Un solo atajo (`PrintScreen`) lanza un menú en Rofi (`capture-menu.sh`) que permite tomar screenshots (pantalla completa, área, ventana) o iniciar/detener grabaciones de pantalla con `wf-recorder`.
- **Gestión de Energía Avanzada:** `hypridle` está configurado para `suspend-then-hibernate`, ideal para laptops. `wlsunset` ajusta la temperatura de la pantalla automáticamente según la hora en Santiago de Chile.

## 🛠️ Dependencias Clave

- **Visual:** `hyprland`, `waybar`, `rofi`, `kitty`, `swayosd`, `swaync`, `sddm`.
- **Theming:** `pywal`, `oomox-cli`, `spicetify-cli`, `ttf-jetbrains-mono-nerd`.
- **Scripts y Automatización:** `fzf`, `jq`, `gnu-stow`, `swayosd-client`.
- **Hardware:** `blueman`, `solaar`, `kdeconnect`, `libfprint-goodixtls-55x4`.
- **Backend:** `polkit-gnome`, `xdg-desktop-portal-hyprland`.

---
*Este setup es la prueba de que un entorno minimalista no tiene por qué sacrificar funcionalidad ni estética.*

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/bat.sh
################################################################################

#!/bin/bash

# --- CONFIG ---
# Check every 60 seconds
CHECK_INTERVAL=60

# Get the battery name (usually BAT0 or BAT1)
BAT=$(ls /sys/class/power_supply | grep '^BAT' | head -n 1)

# Variable to track the last notified level to prevent spam
last_notified=100

while true; do
    # Get current status and capacity
    status=$(cat /sys/class/power_supply/$BAT/status)
    capacity=$(cat /sys/class/power_supply/$BAT/capacity)

    # Only run checks if we are discharging
    if [ "$status" == "Discharging" ]; then
        
        # Level 30%
        if [ $capacity -le 30 ] && [ $capacity -gt 20 ] && [ $last_notified -gt 30 ]; then
            notify-send -u normal -i battery-level-30-symbolic "Battery Low" "Level: ${capacity}%"
            last_notified=30
        fi

        # Level 20%
        if [ $capacity -le 20 ] && [ $capacity -gt 15 ] && [ $last_notified -gt 20 ]; then
            notify-send -u normal -i battery-level-20-symbolic "Battery Low" "Level: ${capacity}%"
            last_notified=20
        fi

        # Level 15% (Getting serious)
        if [ $capacity -le 15 ] && [ $capacity -gt 10 ] && [ $last_notified -gt 15 ]; then
            notify-send -u critical -i battery-level-10-symbolic "Battery Critical" "Plug in charger! (${capacity}%)"
            last_notified=15
        fi

        # Level 10% (Red alert)
        if [ $capacity -le 10 ] && [ $capacity -gt 5 ] && [ $last_notified -gt 10 ]; then
            notify-send -u critical -i battery-level-10-symbolic "BATTERY DYING" "Save your work! (${capacity}%)"
            last_notified=10
        fi

        # Level 5% (Panic mode)
        if [ $capacity -le 5 ] && [ $last_notified -gt 5 ]; then
            notify-send -u critical -i battery-level-0-symbolic "SYSTEM IMMINENT SHUTDOWN" "Bye bye... (${capacity}%)"
            last_notified=5
        fi

    else
        # If charging, reset the notification tracker
        # We set it to 100 so when you unplug, it's ready to notify down again
        if [ "$status" != "Discharging" ]; then
            last_notified=100
        fi
    fi

    sleep $CHECK_INTERVAL
done

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/.gitignore
################################################################################


# Ignore update script log
update.log

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/loguot.sh
################################################################################

#!/usr/bin/env bash

#// Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

#// Set file variables
confDir="$HOME/.config"
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

#// Detect monitor resolution
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

#// Scale config layout and style
wlColms=6
export mgn=$((y_mon * 28 / hypr_scale))
export hvr=$((y_mon * 23 / hypr_scale))

#// Scale font size
export fntSize=$((y_mon * 2 / 100))

#// Detect wallpaper brightness
export BtnCol="white"

#// Eval hypr border radius
hypr_border="${hypr_border:-10}"
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

#// Eval config files
wlStyle="$(envsubst <"${wlTmplt}")"

#// Launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell



################################################################################
ARCHIVO: hypr/.config/hypr/scripts/random_wallpaper.sh
################################################################################

#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Find a random wallpaper from the directory
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the wallpaper using our main script
~/.config/hypr/scripts/set_wallpaper.sh "$RANDOM_WALLPAPER"

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/README.md
################################################################################

# Aqui estan mis scripts de Hyprland
---
Se Incluyen:
- set.wallpaper.sh
- wallpaper-selector.sh

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/screenshot.sh
################################################################################

#!/bin/bash

# --- CONFIG & DIRECTORIES ---
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
RECORDING_DIR="$HOME/Videos/Recordings"
mkdir -p "$SCREENSHOT_DIR" "$RECORDING_DIR"

# Nombres de archivo
TS=$(date +'%Y-%m-%d_%H-%M-%S')
SCREENSHOT_PATH="$SCREENSHOT_DIR/screenshot_$TS.png"
RECORDING_PATH="$RECORDING_DIR/recording_$TS.mp4"

# Noctalia IPC (Para notificaciones o triggers)
IPC="qs -c noctalia-shell ipc call"

# --- LÓGICA DE GRABACIÓN (DETENER) ---
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -l SIGINT wf-recorder
    notify-send -a "System" " Grabación Detenida" "Video guardado en $RECORDING_DIR"
    exit 0
fi

# --- MENÚ (Usando FUZZEL para velocidad instantánea) ---
# Si no tienes fuzzel: sudo pacman -S fuzzel
options="🖼️  Pantalla Completa\n󰆞  Seleccionar Área\n󰖵  Ventana Activa\n  Grabar Área\n⏺️  Grabar Pantalla Completa"

choice=$(echo -e "$options" | fuzzel -d -p "󰄀 Centro de Captura: " --width 30)

case "$choice" in
    "🖼️  Pantalla Completa")
        hyprshot -m output -o "$SCREENSHOT_DIR" -f "screenshot_$TS.png"
        ;;
    "󰆞  Seleccionar Área")
        hyprshot -m region -o "$SCREENSHOT_DIR" -f "screenshot_$TS.png"
        ;;
    "󰖵  Ventana Activa")
        hyprshot -m window -o "$SCREENSHOT_DIR" -f "screenshot_$TS.png"
        ;;
    "  Grabar Área")
        notify-send -a "System" "🔴 Selecciona Área" "La grabación comenzará al soltar."
        wf-recorder -g "$(slurp)" -f "$RECORDING_PATH" --audio &
        ;;
    "⏺️  Grabar Pantalla Completa")
        # Detecta automáticamente el monitor activo para evitar otro menú
        MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
        notify-send -a "System" "🔴 Grabando Pantalla" "Monitor: $MONITOR"
        wf-recorder -o "$MONITOR" -f "$RECORDING_PATH" --audio &
        ;;
    *)
        exit 1
        ;;
esac

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/set_wallpaper.sh
################################################################################

#!/bin/bash

# --- CONFIG & IPC ---
export PATH="${PATH}:$HOME/.local/bin:/usr/local/bin:/usr/bin"
# The Noctalia IPC command
IPC="qs -c noctalia-shell ipc call"

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH=$(realpath "$1")

# --- 1. SET WALLPAPER VIA NOCTALIA ---
# This replaces hyprpaper. Noctalia handles the transition.
$IPC wallpaper set "$WALLPAPER_PATH" eDP-1

# --- 2. GENERATE COLORS WITH PYWAL ---
# -n (no wallpaper) -q (quiet) -t (skip terminal checks)
wal -n -s -t -i "$WALLPAPER_PATH"

if [ $? -ne 0 ]; then
    notify-send "Error" "Pywal failed."
    exit 1
fi

# --- 3. RELOAD KITTY ---
# Sends a signal to all open Kitty instances to reload their colors from ~/.cache/wal/colors-kitty.conf
killall -SIGUSR1 kitty

# --- 4. RELOAD NOCTALIA THEME ---
# Most Noctalia setups watch the CSS files, but this forces a reload
# to ensure the Pywal colors are applied to the bar and dashboard.
$IPC stylesheet reload

# --- 5. NOTIFICATION ---
# Uses Noctalia's own notification system
notify-send -a "System" -i "$WALLPAPER_PATH" "Theme Updated" "Noctalia, Kitty, and synced."

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/update.sh
################################################################################

#!/bin/zsh

# Go to the script's directory to ensure log files are created locally
cd "$(dirname "$0")"

# --- Configuration ---
LOG_FILE="$PWD/update.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
GITIGNORE_FILE="$PWD/.gitignore"

# --- Function for sending notifications ---
# D-Bus is needed for notify-send to work correctly from a script run with sudo
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

notify() {
  notify-send "Pacman Updater" "$1" -i "system-software-update"
}

# --- Automatically ignore the log file in git ---
# Check if the log file is already in .gitignore and add it if not
if ! grep -q "^$(basename "$LOG_FILE")$" "$GITIGNORE_FILE" 2>/dev/null; then
  echo "\n# Ignore update script log" >> "$GITIGNORE_FILE"
  echo "$(basename "$LOG_FILE")" >> "$GITIGNORE_FILE"
fi

# --- Main Script Logic ---
# Redirect all output (stdout and stderr) to both the console and the log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========== Starting Update: $TIMESTAMP =========="

# 1. Update Mirrorlist with Reflector
echo "Updating mirrorlist for best performance..."
if sudo reflector --country 'Chile,Argentina,Brazil,Peru' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist; then
  echo "[OK] Mirrorlist updated successfully."
else
  echo "[ERROR] Failed to update mirrorlist with reflector."
  notify "❌ Error: Failed to update mirrorlist."
  exit 1 # Exit the script with an error code
fi

# 2. Perform Full System Upgrade (Official Repos + AUR)
echo "Starting full system upgrade (Official Repos + AUR)..."
# We remove --noconfirm for safety. It's better to manually confirm packages.
if yay -Syuu --sudoloop; then
  echo "[SUCCESS] System upgrade completed successfully at $(date '+%Y-%m-%d %H:%M:%S')."
  notify "✅ System is up-to-date!"
else
  echo "[ERROR] The update process failed."
  notify "❌ Error: The update process failed. Check the log."
  exit 1 # Exit the script with an error code
fi

echo "=================================================="
echo ""

################################################################################
ARCHIVO: hypr/.config/hypr/scripts/wallpaper-selector.sh
################################################################################

#!/bin/bash

# 1. Definir rutas (OJO AQUI)
# La carpeta donde estan las imagenes
WALL_DIR="$HOME/Dotfiles/Wallpapers"

# La ruta exacta de tu script que aplica el fondo (EL PRIMERO QUE ME MOSTRASTE)
# Si lo tienes en otra parte, cambia esta linea.
SETTER_SCRIPT="$HOME/Dotfiles/hypr/.config/hypr/scripts/set_wallpaper.sh"
# ^^^ REVISA QUE ESTA RUTA SEA REAL. Si no sabes donde está, usa `find ~/Dotfiles -name set_Wallpaper.sh` para buscarlo.

# 2. Comprobar dependencias
if ! command -v fzf &> /dev/null; then
    echo "Error: fzf no está instalado. Ejecuta 'sudo pacman -S fzf'"
    exit 1
fi

# 3. Comando de previsualización para Kitty
# place=ANCHO x ALTO @ POS_X x POS_Y
# Ajusta el 60x60 si la imagen se ve chica o muy grande
PREVIEW_CMD="kitten icat --clear --transfer-mode=memory --stdin=no --place=60x60@30x5 {}"

# 4. Buscar imágenes recursivamente (entra a Gundam y Macross)
# Usamos 'find' para listar todo y 'fzf' para elegir
SELECTED=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | \
    fzf --preview "$PREVIEW_CMD" \
        --preview-window=right:50% \
        --prompt="Fondo > " \
        --height=100% \
        --layout=reverse \
        --border \
        --margin=1 \
        --padding=1)

# 5. Si elegiste algo, aplicar
if [ -n "$SELECTED" ]; then
    notify-send "Fondo seleccionado:" "$SELECTED"

    if [ -f "$SETTER_SCRIPT" ]; then
        bash "$SETTER_SCRIPT" "$SELECTED"
    else
        notify-send "ERROR CRITICO:" "No encuentro el script set_Wallpaper.sh en: $SETTER_SCRIPT Por favor edita este archivo y corrige la ruta SETTER_SCRIPT."
        read -p "Presiona enter para salir..."
    fi
fi
