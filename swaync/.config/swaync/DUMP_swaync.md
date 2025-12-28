==================================================================
 DUMP DE CONFIGURACIÓN: /home/F-Patata/Dotfiles/swaync/.config/swaync
 Fecha: Sat Dec 27 11:26:46 PM -03 2025
==================================================================


################################################################################
AR-CHIVO: /home/F-Patata/Dotfiles/swaync/.config/swaync/config.json
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
        "buttons-grid",
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
                { "label": "", "command": "swaylock", "tooltip": "Lock" },
                { "label": "󰜉", "command": "reboot", "tooltip": "Reboot" },
                { "label": "⏻", "command": "systemctl hibernate", "tooltip": "Hibernate PC" }
            ]
        },
        "notifications": {}
    }
}


################################################################################
AR-CHIVO: /home/F-Patata/Dotfiles/swaync/.config/swaync/style.css
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

