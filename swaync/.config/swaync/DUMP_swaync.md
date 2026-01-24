==================================================================
 DUMP DE CONFIGURACIÓN: swaync/.config/swaync
 Fecha: Fri Jan 23 11:33:51 PM -03 2026
==================================================================


################################################################################
ARCHIVO: swaync/.config/swaync/config.json
################################################################################

{
    "$schema": "/etc/xdg/swaync/configSchema.json",
    "cssPriority": "user",
    "positionX": "center",
    "positionY": "top",
    "layer": "overlay",
    "control-center-layer": "overlay",
    "control-center-width": 500,
    "control-center-margin-top": 2,
    "fit-to-screen": false,
    "hide-on-action": true,
    "widgets": [
        "title",
        "mpris",
        /*"buttons-grid",*/
        "dnd",
        "notifications"
    ],
    "widget-config": {
        "title": {
            "text": "Mundo Hola Patata",
            "clear-all-button": true,
            "button-text": "Format All PCS"
        },
        "mpris": {
            "image-size": 48,
            "image-radius": 12,
            "autohide": true
        },
        "dnd": {},
        "buttons-grid": {
            "actions": [
                { "label": "", "command": "sh $HOME/Dotfiles/hypr/.config/hypr/scripts/wifi.sh", "tooltip": "Network" },
                { "label": "", "command": "blueman-manager", "tooltip": "Bluetooth" },
                { "label": "󰈙", "command": "nautilus", "tooltip": "Files" },
                { "label": "󰻠", "command": "gnome-system-monitor", "tooltip": "System Monitor" },
                { "label": "", "command": "pidof hyprlock || hyprlock", "tooltip": "Lock", "tooltip": "Lock" },
                { "label": "󰜉", "command": "reboot", "tooltip": "Reboot" },
                { "label": "⏻", "command": "systemctl hibernate", "tooltip": "Hibernate PC" }
            ]
        },
        "notifications": {}
    }
}

################################################################################
ARCHIVO: swaync/.config/swaync/README.md
################################################################################

# 🎨 Configuración de Sway Notification Center (SwayNC)

![SwayNC](https://img.shields.io/badge/Notifications-SwayNC-88C0D0?style=for-the-badge)
![CSS](https://img.shields.io/badge/Styling-CSS_&_Pywal-56B6C2?style=for-the-badge&logo=css3&logoColor=white)

Esta es mi configuración para `SwayNC`, que lo transforma de un simple demonio de notificaciones a un **Centro de Control** interactivo y visualmente cohesivo, anclado en la parte superior de la pantalla.

## ✨ Filosofía
- **Funcionalidad Dual:** Sirve tanto para mostrar notificaciones emergentes como para actuar de panel de control rápido, accesible a través de un clic en Waybar.
- **Integración con Pywal:** El `style.css` importa directamente la paleta de colores de `pywal`, asegurando que la apariencia del centro de control y las notificaciones siempre haga juego con el fondo de pantalla.
- **Acceso Rápido:** El `buttons-grid` está configurado con acciones de sistema comunes, permitiendo controlar aspectos clave del PC sin necesidad de abrir una terminal o un menú completo.

## 📂 Estructura de Archivos

- **`config.json`**: Define la **lógica y el layout** del centro de control.
  - `positionX` y `positionY`: Lo anclan en la parte superior central de la pantalla.
  - `widgets`: Define el orden de los elementos: Título, control de medios (MPRIS), cuadrícula de botones, "No Molestar" (DND) y la lista de notificaciones.
  - `widget-config`: Configura cada widget individualmente. Lo más destacado es `buttons-grid`, que mapea íconos a scripts y comandos.

- **`style.css`**: Controla toda la **apariencia visual**.
  - `@import`: Importa `colors-waybar.css` desde la caché de `pywal` para usar variables de color dinámicas (`@background`, `@foreground`, etc.).
  - **Estilo Cohesivo:** El diseño de los widgets, botones y notificaciones imita el estilo de la Waybar (fondos semi-transparentes, bordes redondeados) para crear una experiencia de usuario unificada.

## 🛠️ Centro de Control (`buttons-grid`)

El corazón de esta configuración es la cuadrícula de botones, que proporciona los siguientes atajos:

| Icono | Comando                                | Descripción                        |
| :---: | -------------------------------------- | ---------------------------------- |
| ``   | `.../scripts/wifi.sh`                  | Abre el menú de redes Wi-Fi (Rofi).|
| ``   | `blueman-manager`                      | Abre el gestor de Bluetooth.       |
| `󰈙`   | `nautilus`                             | Lanza el gestor de archivos.       |
| `󰻠`   | `gnome-system-monitor`                 | Abre el monitor del sistema.       |
| ``   | `hyprlock`    | Bloquea la pantalla.               |
| `󰜉`   | `reboot`                               | Reinicia el sistema.               |
| `⏻`   | `systemctl hibernate`                  | Hiberna el sistema.                |


## 🚀 Integración con Waybar

La interacción con `SwayNC` se maneja desde el módulo `custom/notification` en la configuración de Waybar:
- **`exec`:** `swaync-client -swb` obtiene el estado de las notificaciones para mostrar el ícono correcto en la barra.
- **`on-click`:** `swaync-client -t -sw` abre y cierra el centro de control.
- **`on-click-right`:** `swaync-client -d -sw` abre y cierra el modo "No Molestar".

################################################################################
ARCHIVO: swaync/.config/swaync/style.css
################################################################################

/* --- Import your pywal color palette --- */
@import "/home/F-Patata/.cache/wal/colors-waybar.css";

/* --- Define our color scheme based on pywal --- */
@define-color bar-bg alpha(@background, 0.85);
@define-color module-bg alpha(@color0, 0.7);
@define-color module-hover-bg alpha(@color8, 0.9);
@define-color text-main @foreground;
@define-color text-hover @foreground;
@define-color workspace-active-bg @color1;


/* --- General --- */
* {
    border: none;
    border-radius: 9px;
    font-family: "JetBrainsMono Nerd Font", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 9px;
    min-height: 0;
}

/* --- Main Window (Control Center) --- */
.notification-center, .control-center {
    background-color: @bar-bg;
    color: @text-main;
}

/* --- Widgets --- */
.widget {
    background-color: @module-bg;
    margin: 9px;
    padding: 5px;
    transition: background-color 0.3s ease-out;
}

.widget:hover {
    background-color: @module-hover-bg;
}

/* --- Title --- */
.widget-title {
    font-weight: bold;
    font-size: 1.2em;
    color: @text-main;
    margin-bottom: 5px;
}

.widget-title button {
    background-color: transparent;
    color: @text-main;
    text-shadow: none;
}

.widget-title button:hover {
    background-color: @module-hover-bg;
    color: @text-hover;
}

/* --- Buttons Grid --- */
.widget-buttons-grid button {
    background-color: @module-bg;
    color: @text-main;
    font-size: 14px;
    padding: 9px;
}

.widget-buttons-grid button:hover {
    background-color: @module-hover-bg;
    color: @text-hover;
}

/* --- Do Not Disturb Widget --- */
.widget-dnd {
    padding: 9px;
}

/* --- Notifications --- */
.notification {
    background-color: @module-bg;
    border-radius: 9px;
    margin: 9px;
}

.notification-content {
    padding: 9px;
}

.summary {
    font-weight: bold;
    color: @text-main;
}

.body {
    color: @text-main;
}

.notification-action {
    background-color: @workspace-active-bg;
    color: @text-main;
    border-radius: 9px;
    padding: 5px;
    margin: 5px;
}

.notification-action:hover {
    background-color: @module-hover-bg;
    color: @text-hover;
}

/* --- MPRIS (Media Player) --- */
.widget-mpris {
    padding: 9px;
}

.widget-mpris image {
    border-radius: 12px;
}
