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
