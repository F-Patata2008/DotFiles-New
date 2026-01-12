==================================================================
 DUMP DE CONFIGURACIÓN: hypr/.config/hypr
 Fecha: Sun Jan 11 10:13:30 PM -03 2026
==================================================================


################################################################################
AR-CHIVO: hypr/.config/hypr/conf/aesthetics.conf
################################################################################

# Aesthetics
source = ~/.cache/wal/colors-hyprland.conf
layerrule {
    name = Aplicar-BLur-wlogout
    blur = on
    match:namespace = wlogout

}
layerrule {
    name = Aplicar-BLur-logout_dialog
    blur = on
    dim_around = on
    match:namespace = logout_dialog
}
layerrule {
    name = Aplicar-Blur-OSD
    blur = on
    ignore_alpha = 0.5
    match:namespace = swayosd
}

decoration {
    rounding = 5

    blur {
        enabled = true
        passes = 2
        size = 2

        ignore_opacity = true
        noise = 0.02
        contrast = 1.1
        brightness = 1.0
    }

    shadow {
        enabled = false
    }

    }


################################################################################
AR-CHIVO: hypr/.config/hypr/conf/animations.conf
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
AR-CHIVO: hypr/.config/hypr/conf/binds.conf
################################################################################

# Keybindings
$mainMod = SUPER

# Application and utility binds
bind = $mainMod, T, exec, kitty
bind = $mainMod, R, exec, rofi -show drun -show-icons
bind = $mainMod, C, killactive,
bind = $mainMod, E, exec, nautilus
bind = $mainMod, L, exec, pidof hyprlock || hyprlock
bind = $mainMod, W, exec, ~/.config/hypr/scripts/reset_waybar.sh
bind = $mainMod, Q, exec, rofi -show run
bind = $mainMod, B, exec, opera
bind = $mainMod, S, exec, spotify

# Hyprland and script binds
#bind = $mainMod SHIFT, return, hyprexpo:expo, toggle
#bind = $mainMod SHIFT, N, exec, ~/.config/hypr/scripts/nigthligth.sh
bind = $mainMod SHIFT, L, exec, $HOME/.config/hypr/scripts/loguot.sh
bind = $mainMod SHIFT, P, exec, hyprpicker -a
bind = $mainMod SHIFT, E, exec, rofi -show filebrowser
bind = $mainMod SHIFT, R, exec, rofi -modi "emoji:rofimoji" -show emoji
bind = $mainMod SHIFT, N, exec, kitty --class Notas -e sh -c "nvim $HOME/Notas.md"
bind = $mainMod SHIFT, F, fullscreen


# Screenshot binds
bind = , PRINT, exec, ~/.config/hypr/scripts/screenshot.sh
bind = shift, PRINT, exec, hyprshot -m output

# Window and layout binds
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,
bind = $mainMod, V, togglefloating,

# Focus binds
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Workspace binds
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

# Move to workspace binds
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

# Cambiar workspace con Super + Scroll del mouse
bind = SUPER, mouse_down, workspace, e-1
bind = SUPER, mouse_up, workspace, e+1

# Mouse binds
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Multimedia keys
bindel = ,XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise
bindel = ,XF86AudioLowerVolume, exec, swayosd-client --output-volume lower
bindel = ,XF86AudioMute, exec, swayosd-client --output-volume mute-toggle
bindel = ,XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle
bindel = ,XF86MonBrightnessUp, exec, swayosd-client --brightness raise
bindel = ,XF86MonBrightnessDown, exec, swayosd-client --brightness lower

# Player controls
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous

# Clipboard manager
bind = SUPER SHIFT, V, exec,  kitty --class clipse -e 'clipse'


################################################################################
AR-CHIVO: hypr/.config/hypr/conf/general.conf
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
}

misc {
    vfr = true
}


################################################################################
AR-CHIVO: hypr/.config/hypr/conf/input.conf
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
AR-CHIVO: hypr/.config/hypr/conf/plugins.conf
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
AR-CHIVO: hypr/.config/hypr/conf/startup.conf
################################################################################

# --- PLugins ---
#exec-once = hyprpm reload -n


# --- Theming & OSD ---
exec-once = wal -R
exec-once = swayosd-server
exec-once = swaync
exec-once = hyprpaper

# --- Hardware & System Tray ---
exec-once = nm-applet &
exec-once = blueman-applet &  # <--- NUEVO (Bluetooth)
exec-once = udiskie &         # <--- NUEVO (USB Automount)
exec-once = solaar --window=hide --battery-icons=symbolic > /dev/null 2>&1 &
exec-once = waybar &
exec-once = kdeconnect-indicator

# --- Idle & Screen Protection ---
exec-once = hypridle &
# Santiago de Chile Coordinates (-33.4, -70.6)
exec-once = wlsunset -t 3600 -T 6500 -d 1800 -l -33.4 -L -70.6

# --- Backend Services ---
exec-once = /usr/lib/evolution-data-server/evolution-alarm-notify
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = kdeconnectd
exec-once = clipse -listen

# --- Session & Portals (Orden Importante) ---
exec-once = dbus-update-activation-environment --systemd --all
exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # <--- Fix para OBS/Screen Share
exec-once = /usr/lib/xdg-desktop-portal-hyprland
# Descomentado para guardar claves SSH/Git/Spotify
#exec-once = gnome-keyring-daemon --start --components=pkcs11,secrets,ssh

# --- User Apps ---
exec-once = kitty --class "Dotfiles" --directory ~/Dotfiles


################################################################################
AR-CHIVO: hypr/.config/hypr/conf/window.conf
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
AR-CHIVO: hypr/.config/hypr/hypridle.conf
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
AR-CHIVO: hypr/.config/hypr/hyprland.conf
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


################################################################################
AR-CHIVO: hypr/.config/hypr/hyprlock.conf
################################################################################

# ===================================================================
# FINAL WORKING HYPRLOCK CONFIGURATION (v0.9.1)
#
# - Removes invalid configuration blocks for this version.
# - Adds a static label as a visual cue for fingerprint scanning.
# ===================================================================

# -------------------------------------------------------------------
# Define a variable for the font for easy reuse
# -------------------------------------------------------------------
$font = JetBrainsMono Nerd Font


# -------------------------------------------------------------------
# GENERAL
# -------------------------------------------------------------------
general {
    hide_cursor = true
}

# -------------------------------------------------------------------
# BACKGROUND
# -------------------------------------------------------------------
background {
    monitor =
    path = $HOME/Dotfiles//Wallpapers/Gundam/33.jpg
    color = rgba(25, 20, 20, 1.0)
    blur_passes = 0
}

# -------------------------------------------------------------------
# CLOCK & DATE (TOP RIGHT)
# -------------------------------------------------------------------
label {
    monitor =
    text = cmd[update:30000] echo "$(date +"%R")"
    color = rgb(255, 255, 255)
    font_size = 90
    font_family = $font
    position = -30, 0
    halign = right
    valign = top
}

label {
    monitor =
    text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
    color = rgb(255, 255, 255)
    font_size = 25
    font_family = $font
    position = -30, -150
    halign = right
    valign = top
}

# -------------------------------------------------------------------
# CUSTOM "Mundo Hola" LABEL
# -------------------------------------------------------------------
label {
    monitor =
    text = Mundo Hola
    color = rgb(255, 255, 255)
    font_size = 20
    font_family = "Sans Bold"
    position = 0, -110
    halign = center
    valign = center
}

# -------------------------------------------------------------------
# FINGERPRINT HINT LABEL (REPLACES the invalid fingerprint block)
# -------------------------------------------------------------------
label {
    monitor =
    text = Scan Fingerprint or Enter Password
    color = rgb(200, 200, 200) # A slightly dimmer white
    font_size = 16
    font_family = $font
    position = 0, 40 # Positioned just below the input box
    halign = center
    valign = center
}


# -------------------------------------------------------------------
# INPUT FIELD
# -------------------------------------------------------------------
input-field {
    monitor =
    size = 450, 60
    outline_thickness = 3
    inner_color = rgba(0, 0, 0, 0.0)
    rounding = 15

    # --- Gradient colors ---
    outer_color = rgba(33ccffee) rgba(00ff99ee) 45deg
    check_color = rgba(00ff99ee) rgba(ff6633ee) 120deg
    fail_color = rgba(ff6633ee) rgba(ff0066ee) 40deg

    # --- Font and dynamic text ---
    font_color = rgb(143, 143, 143)
    fade_on_empty = false
    hide_input = false
    dots_center = true
    # FIXED: Pango markup with ##RRGGBBAA hex format
    placeholder_text = <span foreground="##8F8F8FB2"><i>󰌾 Logged in as </i><span foreground="##33CCFFE5">$USER</span></span>
    fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
    capslock_color = rgb(255, 204, 0)

    # --- Positioning ---
    position = 0, -20
    halign = center
    valign = center
}


################################################################################
AR-CHIVO: hypr/.config/hypr/hyprpaper.conf
################################################################################

ipc = on
# ===================================================================
# HYPRPAPER CONFIGURATION
#
# This file sets the initial wallpaper and enables IPC (Inter-Process
# Communication) so that scripts can change the wallpaper later.
# ===================================================================

# Set a preload wallpaper. This is the image that will be loaded
# into memory when hyprpaper starts.
# I'm using the path from your example.
preload = /home/F-Patata/Dotfiles/Wallpapers/Gundam/10.jpg

# Set the wallpaper for all monitors. The leading comma means it
# applies to any monitor that doesn't have a specific rule.
# This will be your wallpaper at login.
wallpaper = , /home/F-Patata/Dotfiles/Wallpapers/Gundam/10.jpg

# THIS IS THE MOST IMPORTANT LINE
# It allows hyprpaper to be controlled by the command line (hyprctl).
ipc = on


################################################################################
AR-CHIVO: hypr/.config/hypr/hyprsunset.conf
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
AR-CHIVO: hypr/.config/hypr/monitors.conf
################################################################################

# Generated by nwg-displays on 2025-09-16 at 22:22:45. Do not edit manually.

monitor=eDP-1,1366x768@60.0,0x144,1.0
monitor=HDMI-A-1,1920x1080@60.0,1366x0,1.0


################################################################################
AR-CHIVO: hypr/.config/hypr/README.md
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
AR-CHIVO: hypr/.config/hypr/scripts/.gitignore
################################################################################


# Ignore update script log
update.log


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/loguot.sh
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
AR-CHIVO: hypr/.config/hypr/scripts/phone.sh
################################################################################

#!/bin/zsh

# Find the specific ID for the "Galaxy S8"
DEVICE_ID=$(kdeconnect-cli -a | grep "Galaxy S8" | awk -F': ' '{print $2}' | awk '{print $1}')

ICON="" # Nerd Font icon for phone

if [ -n "$DEVICE_ID" ]; then
    # Use qdbus and crucially, ignore the stderr error messages with 2>/dev/null
    BATTERY_LEVEL=$(qdbus6 org.kde.kdeconnect /modules/kdeconnect/devices/$DEVICE_ID/battery org.kde.kdeconnect.device.battery.charge 2>/dev/null)

    # Check if the command was successful and returned a number
    if [[ -n "$BATTERY_LEVEL" && "$BATTERY_LEVEL" -ge 0 ]]; then
        echo "{\"text\": \"$ICON $BATTERY_LEVEL%\", \"tooltip\": \"Phone Battery: $BATTERY_LEVEL%\"}"
    else
        # This will now correctly trigger if the command fails or phone is truly unreachable
        echo "{\"text\": \"$ICON --%\", \"tooltip\": \"Phone Disconnected\"}"
    fi
else
    # No device named "Galaxy S8" found
    echo "{\"text\": \"$ICON N/A\", \"tooltip\": \"Phone Not Found\"}"
fi


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/random_wallpaper.sh
################################################################################

#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Find a random wallpaper from the directory
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the wallpaper using our main script
~/.config/hypr/scripts/set_wallpaper.sh "$RANDOM_WALLPAPER"


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/README.md
################################################################################

# Aqui estan mis sricots de hyprland


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/reset_waybar.sh
################################################################################

#!/bin/bash
killall -q waybar
waybar &


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/screenshot.sh
################################################################################

#!/bin/bash

# --- DIRECTORIOS ---
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
RECORDING_DIR="$HOME/Videos/Recordings"
mkdir -p "$SCREENSHOT_DIR"
mkdir -p "$RECORDING_DIR"

# --- LÓGICA DE GRABACIÓN ---
if pgrep -x "wf-recorder" > /dev/null; then
    # Si wf-recorder está corriendo, solo mostramos la opción de detener.
    choice=$(echo -e " Detener Grabación" | rofi -dmenu -i -p "Grabación en curso")

    if [ "$choice" = " Detener Grabación" ]; then
        # -l SIGINT envía una señal de "parada limpia"
        pkill -l SIGINT wf-recorder
        notify-send "Grabación Detenida" "El video se ha guardado en $RECORDING_DIR"
    fi
    exit 0
fi

# --- SI NO ESTÁ GRABANDO, MOSTRAMOS EL MENÚ COMPLETO ---

# Nombres de archivo con timestamp
SCREENSHOT_FILE="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
RECORDING_FILE="recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
SCREENSHOT_PATH="$SCREENSHOT_DIR/$SCREENSHOT_FILE"
RECORDING_PATH="$RECORDING_DIR/$RECORDING_FILE"

# Opciones para Rofi (con separadores visuales)
options="🖼️ CAPTURA DE PANTALLA\n󰹑 Pantalla Completa\n󰆞 Seleccionar Área\n󰖵 Ventana Activa\n\n📹 GRABAR VIDEO\n Grabar Área\n⏺️ Grabar Pantalla Completa"

# Preguntar al usuario con Rofi
choice=$(echo -e "$options" | rofi -dmenu -i -p "Centro de Captura")

# Lógica del menú
case "$choice" in
    # --- Capturas de Pantalla ---
    "󰹑 Pantalla Completa")
        hyprshot -m output -o "$SCREENSHOT_DIR" -f "$SCREENSHOT_FILE"
        ;;
    "󰆞 Seleccionar Área")
        hyprshot -m region -o "$SCREENSHOT_DIR" -f "$SCREENSHOT_FILE"
        ;;
    "󰖵 Ventana Activa")
        hyprshot -m window -o "$SCREENSHOT_DIR" -f "$SCREENSHOT_FILE"
        ;;

    # --- Grabación de Video ---
    " Grabar Área")
        notify-send "Grabando Área" "Selecciona el área. La grabación comenzará al soltar."
        wf-recorder -g "$(slurp)" -f "$RECORDING_PATH" --audio &
        notify-send "🔴 ¡GRABANDO!" "Presiona [PrintScreen] de nuevo y elige 'Detener Grabación'."
        ;;
    "⏺️ Grabar Pantalla Completa")
        monitor=$(hyprctl monitors -j | jq -r '.[].name' | rofi -dmenu -i -p "Selecciona un monitor")
        if [ -n "$monitor" ]; then
            notify-send "🔴 ¡GRABANDO!" "Grabando $monitor. Presiona [PrintScreen] y 'Detener'."
            wf-recorder -o "$monitor" -f "$RECORDING_PATH" --audio &
        else
            notify-send "Grabación cancelada."
        fi
        ;;
    *)
        # Si se presiona Escape
        exit 1
        ;;
esac


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/set_wallpaper.sh
################################################################################

#!/bin/bash

# =============================================================================
# SCRIPT DE TEMATIZACIÓN DINÁMICA (Hyprland v0.53+)
# =============================================================================

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH=$(realpath "$1")
THEME_NAME="pywal" # Nombre consistente para evitar confusiones

echo "🚀 Iniciando cambio de tema: $WALLPAPER_PATH"

# --- 1. HYPRPAPER (Arreglo de errores de IPC) ---
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    sleep 1
fi

# Intentar aplicar wallpaper (silenciamos errores por si el IPC tarda en despertar)
hyprctl hyprpaper unload all > /dev/null 2>&1
hyprctl hyprpaper preload "$WALLPAPER_PATH" > /dev/null 2>&1
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH" > /dev/null 2>&1

# --- 2. PYWAL (Generar paleta) ---
wal -q -n -i "$WALLPAPER_PATH"
source "$HOME/.cache/wal/colors.sh" # Cargar variables para usar en el script

# --- 3. RECARGAR INTERFAZ ---
hyprctl reload
swaync-client -rs > /dev/null 2>&1
swaync-client --reload-css > /dev/null 2>&1
killall -SIGUSR2 waybar # Recarga configuración de Waybar sin cerrarla

# --- 4. CONFIGURACIÓN GLOBAL DE MODO OSCURO (Importante para GTK) ---
# Esto quita las barras blancas de las cabeceras
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-color-scheme 'prefer-dark'

# --- 5. OOMOX & GTK SYNC (Segundo plano para no bloquear) ---
notify-send -i "$WALLPAPER_PATH" "Tematización" "Generando paleta GTK..."

(
    # Eliminar procesos previos de oomox para no saturar
    pkill oomox-cli || true

    # Compilar el tema con oomox
    oomox-cli -o "$THEME_NAME" ~/.cache/wal/colors-oomox > /dev/null 2>&1

    # APLICAR EL TEMA (Esto es lo que te faltaba)
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"

    # FIX PARA GTK4 / LIBADWAITA (Pavucontrol, Blueman, etc.)
    # Enlazamos el CSS generado directamente a la carpeta de configuración de GTK4
    mkdir -p "$HOME/.config/gtk-4.0"
    ln -sf "$HOME/.themes/$THEME_NAME/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
    ln -sf "$HOME/.themes/$THEME_NAME/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
    ln -sf "$HOME/.themes/$THEME_NAME/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"

    if command -v pywal-spicetify &> /dev/null; then
        echo "🎨 Sincronizando Spotify con Pywal..."
        pywal-spicetify Sleek > /dev/null 2>&1
        spicetify apply -q > /dev/null 2>&1
    fi


    if pgrep -x "swayosd-server" > /dev/null; then
        echo "🔊 Actualizando SwayOSD..."
        killall swayosd-server
        swayosd-server &
        swayosd-libinput-backend & > /dev/null 2>&1
    fi

    notify-send -i "$WALLPAPER_PATH" "Sistema Actualizado" "Tema GTK y colores aplicados correctamente."
    echo "✅ Todo listo. Tema '$THEME_NAME' aplicado."
) &


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/update.sh
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
AR-CHIVO: hypr/.config/hypr/scripts/wallpaper-selector.sh
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


################################################################################
AR-CHIVO: hypr/.config/hypr/scripts/wifi.sh
################################################################################

#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="󰖩  Enable Wi-Fi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
# Get name of connection
read -r chosen_id <<< "${chosen_network:3}"

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
  	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password: " )
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi

