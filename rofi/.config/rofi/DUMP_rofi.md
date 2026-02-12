==================================================================
 DUMP DE CONFIGURACIÓN: rofi/.config/rofi
 Fecha: Thu Feb 12 04:42:03 PM -03 2026
==================================================================


################################################################################
ARCHIVO: rofi/.config/rofi/config.rasi
################################################################################

/**
 * Rofi - Main Configuration
 *
 * This file defines the behavior of Rofi:
 * - Which modes are enabled (drun, run, window).
 * - Global settings like font and icons.
 * - The theme to use for the visual appearance.
 */
configuration {
    /* --- List of active modes --- */
    /* You can add/remove modes here, like "filebrowser" */
    modi: "drun,run,window,filebrowser, emoji:rofimoji";

    /* --- General settings --- */
    font: "JetBrainsMono Nerd Font 8";
    show-icons: true; /* Required for mode-switcher icons to display */

    /* --- Display names and icons for modes --- */
    display-drun: " Apps ";
    display-run: " Run ";
    display-window: " Windows ";
    display-filebrowser: " Files ";
    display-emoji: "󰞅 Emoji ";

    /* --- Formatting for list items --- */
    drun-display-format: "{name}";
    window-format: "{w} · {c} · {t}";
}

/*
 * This line imports your custom theme.
 * Rofi applies the settings from above, then the visuals from this file.
 */
@import "~/.config/rofi/theme.rasi"

################################################################################
ARCHIVO: rofi/.config/rofi/README.md
################################################################################

# 🚀 Configuración de Rofi Dinámica

![Rofi](https://img.shields.io/badge/Launcher-Rofi-6C7A89?style=for-the-badge)
![Pywal](https://img.shields.io/badge/Theme-Pywal-D8A657?style=for-the-badge)

Esta es una configuración de Rofi modular y dinámica, diseñada para integrarse perfectamente con el resto del escritorio. Utiliza **Pywal** para adaptar sus colores al fondo de pantalla actual, manteniendo una apariencia cohesiva.

## ✨ Filosofía
- **Modularidad:** La configuración se divide en dos archivos: `config.rasi` para el comportamiento y `theme.rasi` para la apariencia.
- **Dinamismo:** Los colores no son fijos. Se importan directamente de la caché de Pywal, asegurando que Rofi siempre combine con el wallpaper.
- **Funcionalidad Multi-modo:** Incluye un `mode-switcher` visible que permite cambiar entre diferentes modos (lanzador de apps, comandos, ventanas, etc.) tanto con el teclado como con el mouse.

## 📂 Estructura de Archivos

- **`config.rasi`**: El archivo principal que define la **lógica** de Rofi.
  - `modi`: Define los modos disponibles (`drun`, `run`, `window`, etc.).
  - `font` y `show-icons`: Configuraciones globales de apariencia.
  - `display-*`: Personaliza los íconos y texto para cada modo en el `mode-switcher`.
  - `@import`: Carga el archivo de tema `theme.rasi`.

- **`theme.rasi`**: El archivo que controla toda la **apariencia visual**.
  - `@import`: La primera línea importa la paleta de colores (`colors-rofi-dark.rasi`) generada por Pywal.
  - `window`: Define la posición (centrado), tamaño, bordes y transparencia.
  - `mainbox`: Organiza los elementos internos (barra de entrada, selector de modo, lista).
  - `mode-switcher`: Da estilo a la barra de botones que permite cambiar de modo.
  - `element.selected`: Define el color de resaltado para el ítem seleccionado.

## 🛠️ Modos Habilitados

Esta configuración viene con los siguientes modos pre-configurados, accesibles a través del `mode-switcher` o `Ctrl+Tab`:

| Icono | Nombre | Comando Rofi         | Descripción                               |
| :---- | :----- | :------------------- | :---------------------------------------- |
| ``   | Apps   | `-show drun`         | Lanza aplicaciones gráficas.              |
| ``   | Run    | `-show run`          | Ejecuta comandos de terminal.             |
| ``   | Windows| `-show window`       | Cambia entre ventanas abiertas.           |
| ``   | Files  | `-show filebrowser`  | Navega por el sistema de archivos.        |
| `󰞅`   | Emoji  | `-show emoji`        | Busca y copia emojis (requiere `rofimoji`). |

## 🚀 Cómo se Integra con el Sistema

1.  **Script de Wallpaper (`set_wallpaper.sh`):**
    - Cuando se cambia el fondo de pantalla, `pywal` se ejecuta.
    - `pywal` actualiza el archivo `~/.cache/wal/colors-rofi-dark.rasi`.
2.  **Lanzamiento de Rofi:**
    - Al ejecutar `rofi`, lee su `config.rasi`.
    - `config.rasi` importa `theme.rasi`.
    - `theme.rasi` importa los colores actualizados de Pywal.

El resultado es un lanzador que no solo es potente, sino que también se siente como una parte integrada y viva del escritorio.

################################################################################
ARCHIVO: rofi/.config/rofi/theme.rasi
################################################################################

/**
 * Rofi theme to match the 'Monolith' Waybar design
 *
 * This file controls all visual aspects: colors, positioning, borders, etc.
 * It is designed to work with the multi-mode setup defined in config.rasi.
 */

/* --- Import Pywal Colors --- */
@import "/home/F-Patata/.cache/wal/colors-rofi-dark.rasi"



/* --- Global Variable Definitions --- */
* {
    /* Define a transparent color variable for all elements to use */
    transparent: rgba(0, 0, 0, 0);

    /* Set global background and text colors */
    background-color: transparent;
    text-color: @foreground; /* from pywal */
}


/* --- Main Window Styling --- */
window {
    /* Positioning */
    location: center;/* Anchor to the top-left of the screen */
    anchor: center;
    x-offset: 3px;
    y-offset: 3px;

    /* Appearance (matches Waybar) */
    background-color: @background; /* from pywal */
    border: 1px;
    border-color: @background;
    border-radius: 5px;

    /* Sizing */
    width: 35%;
    height: 42%;
    padding: 0px;
}


/* --- Main Layout Box --- */
mainbox {
    /* Define the order of widgets: Input bar, then mode switcher, then list */
    children: [ inputbar, mode-switcher, listview ];
}


/* --- Input Bar (where you type) --- */
inputbar {
    children: [ prompt, entry ];
    padding: 5px;
    border: 0 0 1px 0;
    border-color: @foreground; /* Use foreground for a subtle separator */
}

prompt {
    enabled: true;
    padding: 0 15px 0 0;
    text-color: @foreground;
}

entry {
    placeholder: "Search...";
    placeholder-color: @foreground;
}


/* --- NEW: Mode Switcher Styling --- */
mode-switcher {
    padding: 5px;
    spacing: 10px;
    border: 0 0 1px 0;
    border-color: @foreground;
}

button {
    padding: 4px 8px;
    background-color: @background;
    text-color: @foreground;
    border-radius: 3px;
    cursor: pointer;
}

button selected {
    /* Invert colors for the selected button to make it stand out */
    background-color: @foreground;
    text-color: @background;
}


/* --- List of Results --- */
listview {
    padding: 5px 0 0 0;
    columns: 1;
    lines: 8;
    cycle: true;
    dynamic: true;
    layout: vertical;
}


/* --- Individual Result Elements --- */
element {
    orientation: horizontal;
    padding: 5px;

}

element-icon {
    size: 1.5em;
    padding: 0 10px 0 0;
}

element-text {
    vertical-align: 0.5;
}

/* Style for the currently selected result */
element.selected {
    background-color: @foreground; /* Invert colors for selection */
    text-color: @background;
}
