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
