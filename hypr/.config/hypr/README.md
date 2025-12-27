# 🚀 Configuración de Hyprland
*Un entorno de Tiling dinámico, modular y centrado en la eficiencia para Arch Linux.*

![Hyprland](https://img.shields.io/badge/WM-Hyprland-E54B83?style=for-the-badge&logo=hyperspace&logoColor=white)
![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Waybar](https://img.shields.io/badge/Bar-Waybar-2E3440?style=for-the-badge&logo=linux-containers&logoColor=white)
![Pywal](https://img.shields.io/badge/Theme-Pywal-D8A657?style=for-the-badge&logo=linux&logoColor=white)

## ✨ Filosofía
Esta configuración está diseñada para un flujo de trabajo rápido y sin distracciones en una laptop, combinando el poder de un Tiling Window Manager con la funcionalidad de un entorno de escritorio completo. La estética es dinámica y se adapta al wallpaper, mientras que la funcionalidad está potenciada por scripts personalizados que integran `rofi` para una experiencia interactiva.

## 🌟 Características Principales

- **Modularidad Total:** La configuración principal (`hyprland.conf`) actúa como un archivo maestro que simplemente importa módulos desde la carpeta `conf/`. Esto facilita la gestión y modificación de atajos, animaciones, reglas de ventana, etc.
- **Theming Dinámico:** Utiliza `pywal` para generar una paleta de colores basada en el wallpaper actual. El script `set_wallpaper.sh` aplica el tema a Hyprland, Waybar y otras aplicaciones al vuelo.
- **Gestión de Energía Inteligente:** Configuración completa para `hypridle` y `wlsunset` para maximizar la duración de la batería, incluyendo apagado de pantalla, bloqueo automático y suspensión híbrida.
- **Scripts Interactivos con Rofi:** El menú de Wi-Fi (`wifi.sh`) y el de capturas de pantalla (`screenshot.sh`) usan `rofi` para proveer una interfaz gráfica intuitiva sin depender de aplicaciones pesadas.
- **Integración Completa de Hardware:** Incluye soporte para `solaar` (mouse Logitech), `kdeconnect` (integración con el teléfono), `blueman-applet` (Bluetooth) y reglas `udev` para el lector de huellas.
- **Atajos Optimizados:** Keybindings pensados para la productividad, incluyendo el cambio de workspaces con `SUPER + Scroll` y gestión de multimedia con `playerctl`.

## 📂 Estructura de Archivos

La configuración está dividida lógicamente para facilitar su mantenimiento:

```
.
├── hyprland.conf      # Archivo maestro (solo `source`s)
├── conf/              # Directorio de módulos de configuración
│   ├── aesthetics.conf  # Blur, bordes, sombras y efectos visuales.
│   ├── animations.conf  # Configuración de animaciones.
│   ├── binds.conf       # Todos los atajos de teclado y mouse.
│   ├── general.conf     # Opciones generales del WM.
│   ├── input.conf       # Configs de teclado, mouse y touchpad.
│   ├── startup.conf     # Todos los `exec-once` al iniciar sesión.
│   └── window.conf      # Reglas para ventanas (flotantes, workspaces, etc).
├── scripts/           # Scripts personalizados para Waybar, Rofi, fondos, etc.
├── hyprlock.conf      # Configuración de la pantalla de bloqueo.
├── hypridle.conf      # Configuración del demonio de inactividad.
├── hyprpaper.conf     # Configuración del gestor de fondos de pantalla.
└── monitors.conf      # Configuración de monitores (generado por nwg-displays).
```

## 🛠️ Dependencias Clave

Para que esta configuración funcione, se necesitan los siguientes paquetes:

- **Visual:** `hyprland`, `hyprlock`, `hyprpaper`, `waybar`, `rofi`, `kitty`, `swayosd`, `swaync`, `nwg-displays`.
- **Theming:** `pywal`, `oomox` (para el tema GTK), `noto-fonts-emoji`, `ttf-jetbrains-mono-nerd`.
- **Utilidades:** `nm-applet`, `blueman-applet`, `solaar`, `kdeconnect`, `udiskie`, `playerctl`, `hyprshot`, `jq`.
- **Backend:** `polkit-gnome`, `xdg-desktop-portal-hyprland`.

## ⌨️ Atajos Esenciales

- `SUPER + T`: Abrir terminal (Kitty).
- `SUPER + R`: Lanzador de aplicaciones (Rofi).
- `SUPER + C`: Cerrar ventana activa.
- `SUPER + L`: Bloquear pantalla (`hyprlock`).
- `SUPER + Flechas`: Moverse entre ventanas.
- `SUPER + Scroll (rueda)`: Cambiar de workspace.
- `PrintScreen`: Menú de captura de pantalla (Rofi + Hyprshot).

---
*Este no es solo un "rice", es un sistema de trabajo.*
