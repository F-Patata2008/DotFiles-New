==================================================================
 DUMP DE CONFIGURACIÓN: waybar/.config/waybar
 Fecha: Wed Feb 18 05:24:59 PM -03 2026
==================================================================


################################################################################
ARCHIVO: waybar/.config/waybar/config.jsonc
################################################################################

{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 0,

    "modules-left": [
        "custom/logo",
        "hyprland/workspaces",
        "custom/separator",
        "hyprland/window"
    ],
    "modules-center": [
        "custom/notification",
        "cpu",
        "memory"
    ],
    "modules-right": [
        "power-profiles-daemon",
        "custom/separator",
        "tray",
        //"custom/separator",
        //"custom/suspend",
        "custom/separator",
        "pulseaudio",
        "custom/separator",
        "network",
        "custom/separator",
        "battery",
        "custom/separator",
        "custom/phone-battery", // Add this
        "custom/separator",
        "custom/bluetooth",
        "custom/separator",
        "custom/wallpaper",
        "custom/separator",
        "clock",
        "custom/separator",
        "custom/power",
    ],


    "custom/logo": {
        "format": "",
        "tooltip": true,
        "tooltip-format": "I use Arch BTW",
        "on-click": "rofi -show drun",
    },

    "hyprland/workspaces": {
        "persistent-workspaces": { "1": [], "2": [], "3": [] },
        "format": "{icon}",
        "format-icons": { "1": "1", "2": "2", "3": "3", "4": "4" }
    },

    "custom/separator": {
        "format": "|",
        "tooltip": false
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "󰖁",
        "on-click": "pavucontrol",
        "format-icons": { "default": ["", "", ""] }
    },

    "network": {
        "format-wifi": "󰤨 {essid}",
        "format-ethernet": "󰈀",
        "format-disconnected": "󰤮",
        "tooltip-format-wifi": "{essid} ({bandwidthTotalBytes})",
        "on-click": "nm-connection-editor"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄{capacity}%",
        "format-plugged": "  {capacity}%",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "on-update": "[[ {capacity} -le 30 && {capacity} -gt 15 && {status} != 'charging' ]] && notify-send -u normal 'Battery Low' 'Battery at {capacity}%! Please connect charger.' || [[ {capacity} -le 15 && {status} != 'charging' ]] && notify-send -u critical 'Battery Critical' 'Battery at {capacity}%! System may shut down soon.'"
    },

    "custom/bluetooth": {
        "format": "󰂯",
        "on-click": "blueman-manager",
        "tooltip": false
    },

    "custom/wallpaper": {
        "format": "󰋩",
        "on-click": "kitty --class Select-Wallpaper -e bash $HOME/.config/hypr/scripts/wallpaper-selector.sh",
        "tooltip": false
    },

    "custom/power": {
        "format": "",
        "on-click": "$HOME/.config/hypr/scripts/loguot.sh",
        "tooltip": false
    },
    "clock": {
        "interval": 60,
        "tooltip": true,
        "format": "{:%H:%M}",
        "tooltip-format": "{:%d-%m-%y}",
    },
    "power-profiles-daemon": {
        "format": "{icon}",
        "tooltip-format": "Power profile: {profile}\nDriver: {driver}",
        "tooltip": true,
        "format-icons": {
            "default": "",
            "performance": "",
            "balanced": "",
            "power-saver": ""
        }
    },
    "custom/notification": {
        "tooltip": false,
        "format": "Mundo Hola {icon} {text}",
        "format-icons": {
            "notification": "<span foreground='red'><sup></sup></span>",
            "none": "",
            "dnd-notification": "<span foreground='red'><sup></sup></span>",
            "dnd-none": ""
        },
        "return-type": "json",
        "exec-if": "which swaync-client",
        "exec": "swaync-client -swb",
        "on-click": "sleep 0.1 && swaync-client -t -sw",
        "on-click-right": "swaync-client -d -sw",
        "escape": true
    },
    "cpu": {
        "format": "  {usage}%",
        "tooltip": true,
        "on-click": "gnome-system-monitor"
    },
    "memory": {
        "format": "  {}%    󰾷 {swapPercentage}%",
    	"tooltip": true,
        "on-click": "gnome-system-monitor"
    },
    "custom/phone-battery": {
        "format": " {} ",
        "return-type": "json",
        "interval": 60, // Check every 30 seconds
        "exec": "$HOME/.config/hypr/scripts/phone.sh"
    },
    "tray": {
        "icon-size": 12,
        "spacing": 10,
        "icons": {
            "blueman": "bluetooth",
            "Solaar": "󰦋",
            "TelegramDesktop": "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png"
        }
    }
}

################################################################################
ARCHIVO: waybar/.config/waybar/README.md
################################################################################

# 🚀 Configuración de Waybar para Hyprland

![Waybar](https://img.shields.io/badge/Bar-Waybar-2E3440?style=for-the-badge&logo=linux-containers&logoColor=white)
![Pywal](https://img.shields.io/badge/Theme-Pywal-D8A657?style=for-the-badge)
![Nerd Fonts](https://img.shields.io/badge/Icons-Nerd_Fonts-61AFEF?style=for-the-badge)

Esta es una configuración de Waybar altamente personalizada, diseñada para ser la pieza central de un escritorio Hyprland dinámico y funcional. Su apariencia se adapta completamente al fondo de pantalla a través de **Pywal**, y extiende su funcionalidad con una serie de **módulos personalizados** que se integran con scripts de shell.

## ✨ Filosofía
- **Cohesión Visual:** El estilo (`style.css`) importa directamente la paleta de colores generada por `pywal`, asegurando que la barra siempre haga juego con el wallpaper, Rofi y la terminal.
- **Información a simple vista:** La barra está dividida en tres secciones (izquierda, centro, derecha) para presentar la información de forma lógica y sin saturar.
- **Interactividad:** La mayoría de los módulos son clickeables, lanzando aplicaciones relevantes (`pavucontrol`, `nm-connection-editor`, etc.) o ejecutando scripts personalizados.

## 📂 Estructura de Archivos

- **`config.jsonc`**: Define la **estructura y comportamiento** de la barra.
  - `modules-left/center/right`: Organiza los módulos en la barra.
  - **Módulos Nativos:** Utiliza módulos integrados de Waybar como `hyprland/workspaces`, `cpu`, `memory`, `network`, `pulseaudio`, `battery` y `tray`.
  - **Módulos Personalizados (`custom/`):** La verdadera potencia del setup, cada uno ejecuta un script o comando para mostrar información específica.

- **`style.css`**: Controla toda la **apariencia visual**.
  - `@import`: Importa `colors-waybar.css` de Pywal para obtener las variables de color (`@background`, `@foreground`, `@color1`, etc.).
  - **Estilo "Monolith":** Los módulos están agrupados en "bloques" con fondo semi-transparente, dando una apariencia moderna y limpia.
  - **Estados Visuales:** Utiliza clases CSS (ej: `#battery.warning`) para cambiar el color de los módulos según su estado.

## 🛠️ Módulos Personalizados Destacados

| Módulo                  | Icono | `on-click` / `exec`                                   | Descripción                                                              |
| ----------------------- | :---: | ----------------------------------------------------- | ------------------------------------------------------------------------ |
| `custom/logo`           | ``   | `rofi -show drun`                                     | Muestra el logo de Arch y actúa como lanzador de aplicaciones.           |
| `custom/notification`   | ``   | `swaync-client`                                       | Se integra con `SwayNC` para mostrar el estado de las notificaciones.    |
| `custom/phone-battery`  | ``   | `.../scripts/phone.sh`                                | Ejecuta un script que usa `kdeconnect-cli` para mostrar la batería del teléfono. |
| `custom/bluetooth`      | `󰂯`   | `blueman-manager`                                     | Abre el gestor de Bluetooth.                                             |
| `custom/wallpaper`      | `󰋩`   | `.../scripts/random_wallpaper.sh`                     | Cambia el fondo de pantalla y actualiza el tema de todo el sistema.    |
| `custom/power`          | ``   | `.../scripts/loguot.sh`                               | Abre el menú de salida `wlogout`.                                        |

## 🎨 Integración con Pywal

El `style.css` es el núcleo de la integración. Las variables de color definidas al principio del archivo son reemplazadas por los valores de `~/.cache/wal/colors-waybar.css` cada vez que Waybar se recarga.

El script `reset_waybar.sh` (`killall waybar && waybar &`) se encarga de forzar esta recarga después de que `pywal` genera una nueva paleta, asegurando que los cambios de color se apliquen instantáneamente.

################################################################################
ARCHIVO: waybar/.config/waybar/style.css
################################################################################

@import "/home/F-Patata/.cache/wal/colors-waybar.css";

/* --- Define our color scheme --- */
/* AHORA USAMOS LAS VARIABLES DE PYWAL */
@define-color bar-bg alpha(@background, 0.75);
@define-color module-bg alpha(@color0, 0.7);
@define-color module-hover-bg alpha(@color8, 0.9);
@define-color text-main @foreground;
@define-color text-hover @foreground;
@define-color workspace-active-bg @color1;
@define-color workspace-hover-bg @color8;
@define-color arch-icon-hover #1793d1;            /* Arch icon hover color */

/* --- Global Settings --- */
* {
    border: none;
    border-radius: 9px; /* Changed corner radius to 9px */
    font-family: "JetBrainsMono Nerd Font", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 8px;   /* Changed global font size to 9px */
    min-height: 0;
    transition: background-color .3s ease-out; /* Smooth transitions */
}

/* --- The Bar Itself --- */
window#waybar {
    background: @bar-bg;
    color: @text-main;
    transition: background-color .5s;
}

/* --- Module Group Styling --- */
.modules-left,
.modules-center,
.modules-right {
    background: @module-bg;
    margin: 2px 9px; /* Adjusted margin to use 9px horizontally */
    padding: 0 5px; /* Kept small padding for the container */
}

.modules-left {
    padding-left: 0;
}

.modules-right {
    padding-right: 0;
}

/* --- General Module Styling --- */
#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#power-profiles-daemon,
#language,
#mpd,
#custom-bluetooth,
#custom-wallpaper,
#custom-power,
#hyprland-window {
    padding: 0 9px; /* Changed module padding to 9px */
}

/* --- Hover Effects for Modules --- */
#clock:hover,
#battery:hover,
#cpu:hover,
#memory:hover,
#disk:hover,
#temperature:hover,
#backlight:hover,
#network:hover,
#pulseaudio:hover,
#wireplumber:hover,
#custom-media:hover,
#tray:hover,
#mode:hover,
#idle_inhibitor:hover,
#scratchpad:hover,
#power-profiles-daemon:hover,
#language:hover,
#mpd:hover,
#custom-bluetooth:hover,
#custom-wallpaper:hover,
#custom-power:hover {
    background: @module-hover-bg;
}

/* --- Workspace Styles --- */
#workspaces {
    background: transparent;
    padding: 0 5px;
}

#workspaces button {
  background: transparent;
  font-weight: 900;
  color: @text-main;
  /* Font size is inherited from the global 9px setting */
}

#workspaces button.active {
    background: @workspace-active-bg;
}

#workspaces button:hover {
  background: @workspace-hover-bg;
  color: @text-hover;
  box-shadow: none;
}

/* --- Specific Module Styles --- */

/* Arch Logo */
#custom-logo {
    margin-left: 5px;
    padding: 0 9px; /* Changed padding to 9px */
    font-size: 14px; /* Scaled down icon size to match smaller text */
    transition: color .5s;
    color: @text-main;
}

#custom-logo:hover {
    color: @arch-icon-hover;
}

/* Separator - Hide it as the new style uses spacing */
#custom-separator {
    font-size: 1px;
    padding: 0;
    margin: 0;
    color: transparent;
}


/* This is the NEW section to replace the old one */
#battery.warning {
    background-color: #F39C12; /* A nice orange color */
}

#battery.critical {
    background-color: #E74C3C; /* A solid red color */
}

#battery.charging, #battery.plugged {
    background-color: #26A65B; /* A pleasant green color */
}



#custom-suspend.pmode-never { color: #e74c3c; }
#custom-suspend.pmode-ultra { color: #f1c40f; }
#custom-suspend.pmode-xtra { color: #2ecc71; }
#custom-suspend.pmode-normal { color: #3498db; }
#custom-suspend.pmode-school { color: #8e44ad; }
#custom-suspend.pmode-unk { color: #95a5a6; }
