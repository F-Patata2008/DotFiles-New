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
* **`ohmyzsh/`**: Instalación de Oh My Zsh (gestionado como un submódulo de Git).
    * _Ubicación:_ `~/.oh-my-zsh/`
* **`rofi/`**: Configuración de Rofi, el lanzador de aplicaciones.
    * _Ubicación:_ `~/.config/rofi/`
* **`swaylock/`**: Configuración del bloqueador de pantalla Swaylock.
    * _Ubicación:_ `~/.config/swaylock/`
* **`swaync/`**: Configuración del gestor de notificaciones SwayNC.
    * _Ubicación:_ `~/.config/swaync/`
* **`wal/`**: Configuraciones personalizadas para Pywal (si existen, p.ej. plantillas).
    * _Ubicación:_ `~/.config/wal/` (si aplica)
* **`waybar/`**: Configuración de la barra de estado Waybar (`config.jsonc`, `style.css`).
    * _Ubicación:_ `~/.config/waybar/`
* **`zsh/`**: Configuración de Zsh (`.zshrc`) y Powerlevel10k (`.p10k.zsh`).
    * _Ubicación:_ `~/.zshrc`, `~/.p10k.zsh`

## Dependencias

Para que estas configuraciones funcionen correctamente, necesitarás instalar los siguientes programas y herramientas en tu sistema Arch Linux. La mayoría se instalarán automáticamente al ejecutar el script de instalación.

* **Compositor Wayland**: `hyprland`
* **Barra de Estado**: `waybar`
* **Lanzador de Aplicaciones**: `rofi`
* **Emulador de Terminal**: `kitty`
* **Editor de Texto**: `neovim`
* **Shell**: `zsh`
* **Framework para Zsh**: `oh-my-zsh` (gestionado como submódulo)
* **Tema Zsh Prompt**: `powerlevel10k-git` (se instala desde el AUR)
* **Bloqueador de Pantalla**: `swaylock`
* **Herramienta de Información del Sistema**: `fastfetch`
* **Gestor de Notificaciones**: `swaync`
* **Herramienta de Theming**: `pywal` (`python-pywal`)
* **Utilidades de Sistema**:
    * `nm-applet` (Applet de NetworkManager)
    * `swayosd` (Para OSD de volumen/brillo)
    * `brightnessctl` (Control de brillo)
    * `playerctl` (Control de medios)
    * `wlogout` (Menú de logout/apagado)
    * `hyprshot` (Herramienta de captura de pantalla)
    * `clipse` (Gestor de portapapeles)
    * `pavucontrol` (Control de volumen de PulseAudio)
    * `gnome-system-monitor` (Monitor de sistema GNOME, opcional para clics en Waybar)
    * `polkit-gnome` (o un agente polkit similar)
    * `swayidle` (Gestión de inactividad)
    * `libnotify` (para `notify-send`)
    * `git` (para clonar el repositorio)
    * `gnome-keyring` (para guardar credenciales si usas nm-applet)
* **Gestor de Dotfiles**: `stow`
* **Compiladores**: `gcc` y `g++`
* **Fuentes**: `nerd-fonts-fira-code`
* **LaTeX**: `biber`, `texlive`

## Instalación

Sigue estos pasos para desplegar los dotfiles en tu sistema. El script **`install.sh`** automatizará la mayor parte del proceso.

1.  **Clonar el Repositorio (con Submódulos):**
    Abre una terminal y clona el repositorio. El flag `--recursive` es crucial para descargar el submódulo de Oh My Zsh.
    ```bash
    git clone --recursive git@github.com:F-Patata2008/DotFiles-New.git ~/Dotfiles
    ```

2.  **Navegar al Directorio de Dotfiles:**
    ```bash
    cd ~/Dotfiles
    ```

3.  **Ejecutar el Script de Instalación:**
    Haz el script ejecutable y luego ejecútalo. El script se encargará de instalar las dependencias de `pacman`, `yay`, temas, repositorios personales y de configurar tus dotfiles con `stow`.
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
    **Importante**: El script te hará algunas preguntas interactivas, como la ID de tu lector de huellas y si quieres ejecutar los pasos de post-instalación de inmediato. Presta atención a las instrucciones en la terminal.

4.  **Pasos Post-Instalación (Manuales):**
    Una vez que el script finalice, deberás realizar algunas acciones manuales para que todo funcione correctamente.
    * **Reiniciar el sistema**: Para que los cambios de grupos de usuario (como `input`) y la configuración del entorno surtan efecto.
    * **Activar el tema de Plymouth**:
        ```bash
        sudo plymouth-set-default-theme -R minecraft-theme
        ```
    * **Reconstruir la configuración de GRUB**: Si no lo hiciste durante la instalación.
        ```bash
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        ```

