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
