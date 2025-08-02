# Mis Dotfiles de Hyprland

Este repositorio contiene la configuración personal de mi entorno de escritorio en Arch Linux, utilizando el compositor Hyprland. Todas las configuraciones están gestionadas eficientemente con [GNU Stow](https://www.gnu.org/software/stow/), lo que facilita su despliegue y mantenimiento.

## Tabla de Contenidos

- [Características Destacadas](#características-destacadas)
- [Configuraciones Incluidas](#configuraciones-incluidas)
- [Dependencias](#dependencias)
- [Instalación](#instalación)
- [Capturas de Pantalla](#capturas-de-pantalla) (Opcional)
- [Agradecimientos](#agradecimientos) (Opcional)

---

## Características Destacadas

Mi setup se enfoca en una experiencia de usuario limpia, rápida y visualmente atractiva, con un fuerte énfasis en la productividad y la personalización.

* **Hyprland**: Compositor Wayland altamente configurado con atajos de teclado personalizados, animaciones fluidas y efectos visuales sutiles.
    * **Swaylock**: Bloqueador de pantalla integrado para seguridad.
    * **Swayidle**: Gestión de inactividad para ahorro de energía y bloqueo automático.
    * **Hyprshot**: Herramienta sencilla para capturas de pantalla rápidas.
* **Waybar**: Barra superior altamente personalizada y dinámica que muestra información esencial del sistema (CPU, RAM, batería, red, audio, etc.), gestión de perfiles de energía, y notificaciones.
* **Zsh con Powerlevel10k**: Un potente y visualmente impresionante entorno de línea de comandos, optimizado para la velocidad y la información.
* **Neovim**: Mi editor de texto principal, configurado con un entorno de desarrollo moderno y eficiente.
* **Kitty**: Un emulador de terminal rápido y rico en funciones.
* **Rofi**: Lanzador de aplicaciones y selector de comandos multifuncional.
* **Pywal (Wal)**: Integración de temas dinámicos que extraen los colores del fondo de pantalla para aplicar a las aplicaciones compatibles y la barra.
* **Utilidades de Escritorio**: Integración de herramientas para gestión de notificaciones (swaync), control de portapapeles (clipse), y control de volumen/brillo (swayosd).

## Configuraciones Incluidas

Cada uno de estos directorios representa un "paquete" de Stow que gestiona configuraciones en su ubicación estándar (`~/.config/` o `~/`):

* **`fastfetch/`**: Configuración para Fastfetch, la herramienta de información del sistema.
    * _Ubicación:_ `~/.config/fastfetch/`
* **`hypr/`**: Toda la configuración de Hyprland (archivos `.conf` y scripts auxiliares).
    * _Ubicación:_ `~/.config/hypr/`
* **`kitty/`**: Configuración del emulador de terminal Kitty.
    * _Ubicación:_ `~/.config/kitty/`
* **`nvim/`**: Configuración de Neovim.
    * _Ubicación:_ `~/.config/nvim/`
* **`ohmyzsh/`**: Instalación de Oh My Zsh.
    * _Ubicación:_ `~/.oh-my-zsh/`
* **`rofi/`**: Configuración de Rofi, el lanzador de aplicaciones.
    * _Ubicación:_ `~/.config/rofi/`
* **`swaylock/`**: Configuración del bloqueador de pantalla Swaylock.
    * _Ubicación:_ `~/.config/swaylock/`
* **`swaync/`**: Configuración del gestor de notificaciones SwayNC.
    * _Ubicación:_ `~/.config/swaync/` # <-- Añade esto
* **`wal/`**: Configuraciones personalizadas para Pywal (si existen, p.ej. plantillas).
    * _Ubicación:_ `~/.config/wal/` (si aplica)
* **`waybar/`**: Configuración de la barra de estado Waybar (`config.jsonc`, `style.css`).
    * _Ubicación:_ `~/.config/waybar/`
* **`zsh/`**: Configuración de Zsh (`.zshrc`) y Powerlevel10k (`.p10k.zsh`).
    * _Ubicación:_ `~/.zshrc`, `~/.p10k.zsh`

## Dependencias

Para que estas configuraciones funcionen correctamente, necesitarás instalar los siguientes programas y herramientas en tu sistema Arch Linux. Utiliza tu gestor de paquetes (pacman) para la mayoría de ellos.

* **Compositor Wayland**: `hyprland`
* **Barra de Estado**: `waybar`
* **Lanzador de Aplicaciones**: `rofi`
* **Emulador de Terminal**: `kitty`
* **Editor de Texto**: `neovim`
* **Shell**: `zsh`
* **Framework para Zsh**: `oh-my-zsh` (se instala automáticamente si no está presente)
* **Tema Zsh Prompt**: `powerlevel10k-git` (usualmente del AUR, configurado con `p10k configure`)
* **Bloqueador de Pantalla**: `swaylock`
* **Herramienta de Información del Sistema**: `fastfetch`
* **Gestor de Notificaciones**: `swaync`
* **Herramienta de Theming**: `pywal` (`python-pywal`)
* **Utilidades de Sistema**:
    * `nm-applet` (Applet de NetworkManager)
    * `swayosd` (Para OSD de volumen/brillo, instalar `swayosd-git` del AUR)
    * `brightnessctl` (Control de brillo)
    * `playerctl` (Control de medios)
    * `wlogout` (Menú de logout/apagado)
    * `hyprshot` (Herramienta de captura de pantalla, instalar `hyprshot-git` del AUR)
    * `clipse` (Gestor de portapapeles, instalar `clipse-git` del AUR)
    * `pavucontrol` (Control de volumen de PulseAudio)
    * `gnome-system-monitor` (Monitor de sistema GNOME, opcional para clics en Waybar)
    * `polkit-gnome` (o un agente polkit similar como `hyprland-polkit-agent-git` del AUR)
    * `swayidle` (Gestión de inactividad)
    * `libnotify` (para `notify-send`, generalmente ya está instalado o parte de `dunst`)
    * `git` (para clonar el repositorio)
    * `gnome-keyring` (para guardar credenciales si usas nm-applet)
* **Gestor de Dotfiles**: `stow`

## Instalación

Sigue estos pasos para desplegar los dotfiles en tu sistema:

1.  **Clona el Repositorio:**
    Abre una terminal y clona el repositorio en tu directorio home:
    ```bash
    git clone [https://github.com/F-Patata2008/Dotfiles](https://github.com/F-Patata2008/Dotfiles) ~/Dotfiles
    ```

2.  **Navega al Directorio de Dotfiles:**
    ```bash
    cd ~/Dotfiles
    ```

3.  **Ejecuta el Script de Instalación:**
    Este script se encargará de crear los enlaces simbólicos usando Stow.
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
    **Importante**: Si ya tienes archivos de configuración en tu directorio `~/.config/` o `~/` que serían reemplazados por los enlaces simbólicos, Stow te avisará de un conflicto. Deberías hacer una copia de seguridad y/o mover esos archivos existentes antes de ejecutar el script (e.g., `mv ~/.config/hypr ~/.config/hypr.bak`).

4.  **Pasos Post-Instalación:**
    * **Reinicia Hyprland**: Para que todos los cambios de Hyprland y Waybar surtan efecto, cierra tu sesión actual y vuelve a iniciar, o usa `hyprctl reload` si ya estás en Hyprland.
    * **Reconstruye la caché de Pywal**: Ejecuta `wal -R` en tu terminal para generar y aplicar un nuevo esquema de colores basado en tu fondo de pantalla actual. Esto es crucial para la integración visual.
    * **Configura Powerlevel10k**: Después de reiniciar tu Zsh, es posible que necesites ejecutar `p10k configure` para personalizar el prompt a tu gusto si aún no lo has hecho.

## Capturas de Pantalla (Opcional)

Puedes añadir aquí algunas capturas de pantalla de tu escritorio para mostrar tu configuración. Crea una carpeta `screenshots/` dentro de tu repo y enlaza las imágenes aquí.

![Captura de pantalla 1](screenshots/screenshot1.png)
![Captura de pantalla 2](screenshots/screenshot2.png)

## Agradecimientos (Opcional)

* Inspirado por otros proyectos de dotfiles y configuraciones de Hyprland.
* Un agradecimiento especial a los desarrolladores de Hyprland, Waybar, Rofi y todas las demás herramientas de código abierto utilizadas.
