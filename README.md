# Mis Dotfiles de Hyprland

Este repositorio contiene la configuración personal de mi entorno de escritorio en Arch Linux, utilizando el compositor Hyprland. Todas las configuraciones están gestionadas eficientemente con [GNU Stow](https://www.gnu.org/software/stow/) y un script de instalación maestro que automatiza todo el proceso.

## Tabla de Contenidos

- [Características Destacadas](#características-destacadas)
- [¿Qué Hace el Instalador?](#qué-hace-el-instalador)
- [Instalación](#instalación)
- [Configuraciones Incluidas](#configuraciones-incluidas)

---

## Características Destacadas

Mi setup se enfoca en una experiencia de usuario limpia, rápida y visualmente atractiva, con un fuerte énfasis en la productividad y la personalización.

- **Sistema de Instalación Automatizado**: Un único script (`install.sh`) gestiona la instalación de paquetes, configuración de hardware (lector de huellas), optimizaciones de energía y despliegue de todos los dotfiles.
- **Hyprland y Ecosistema**: Compositor Wayland configurado con atajos de teclado, animaciones fluidas, y plugins como `hyprexpo`. Incluye `hyprlock`, `hypridle`, `hyprpaper`, etc.
- **Temas Personalizados**: Incluye el tema de GRUB `minegrub` y un tema de Plymouth `minecraft`, que se instalan y configuran automáticamente.
- **Waybar**: Barra superior altamente personalizada y dinámica.
- **Zsh con Powerlevel10k**: Un potente y visualmente impresionante entorno de línea de comandos.
- **Neovim**: Configuración de desarrollo moderna y eficiente.
- **Soporte de Hardware Específico**:
  - **Lector de Huellas Goodix**: Script interactivo para instalar el firmware experimental.
  - **Optimización para Laptops Lenovo**: Configuración de `tlp` y `powertop` para maximizar la duración de la batería.
  - **Aceleración de Vídeo AMD**: Habilitado por defecto para una reproducción de vídeo fluida y eficiente.

## ¿Qué Hace el Instalador?

El script `Install/install.sh` es el cerebro de este repositorio. Al ejecutarse, realiza los siguientes pasos de forma automática:

1.  **Verificación Previa**: Comprueba la conexión a internet.
2.  **Instalación Robusta de Paquetes**: Habilita el repositorio `multilib` e instala todos los paquetes de `pacman` y `AUR` de forma individual para evitar que un solo fallo detenga todo el proceso.
3.  **Configuración de Zsh**: Clona `Oh My Zsh` y `Powerlevel10k`.
4.  **Instalación de Firmware (Interactivo)**: Te pregunta si deseas instalar el firmware para el lector de huellas Goodix.
5.  **Configuración Segura del Sistema**: Edita de forma segura los archivos de autenticación (PAM) para habilitar el lector de huellas en `sudo`, la pantalla de login (GDM) y las ventanas de autenticación gráfica (Polkit), sin sobrescribir archivos críticos.
6.  **Optimización de Hardware**: Crea e habilita un servicio de `systemd` para `powertop` para auto-ajustar el consumo de energía en cada arranque.
7.  **Restauración de Temas y Configuración de Arranque**: Copia los archivos de configuración para GRUB, Plymouth (animación de arranque), hibernación y el mapa de teclado de la TTY.
8.  **Habilitación de Servicios**: Activa servicios esenciales como `NetworkManager`, `bluetooth`, `tlp`, `fprintd` y `cups`.
9.  **Reconstrucción de Imágenes de Arranque**: Ejecuta `mkinitcpio` y `grub-mkconfig` para aplicar todos los cambios.
10. **Instalación de Plugins de Hyprland**: Utiliza `hyprpm` para instalar plugins como `hyprexpo`.
11. **Despliegue de Dotfiles con Stow**: Crea los enlaces simbólicos para todas las configuraciones personales (Hyprland, Kitty, Neovim, etc.).
12. **Establecer Zsh como Shell por Defecto**.

## Instalación

El proceso de instalación asume que has completado una **instalación base de Arch Linux**.

1.  **Paso Previo: Instalación Base de Arch Linux**
    Necesitas un sistema Arch mínimo con un usuario, `sudo`, `git` y una conexión a internet. Para una guía detallada, consulta el documento:
    **[Guía de Instalación Base (`Install/InstallArch.md`)](./Install/InstallArch.md)**

2.  **Clonar el Repositorio (con Submódulos)**
    Abre una terminal y clona el repositorio. El flag `--recursive` es crucial para descargar los submódulos de Git (como Oh My Zsh).
    ```bash
    git clone --recursive https://github.com/F-Patata2008/DotFiles-New.git ~/Dotfiles
    ```

3.  **Ejecutar el Script de Instalación Maestro**
    Navega al directorio `Install`, haz el script ejecutable y ejecútalo.
    ```bash
    cd ~/Dotfiles/Install
    chmod +x install.sh
    ./install.sh
    ```
    El script se encargará de todo lo demás. Presta atención a las preguntas que te haga, como la ID de tu lector de huellas.

4.  **Paso Final: Reiniciar**
    Una vez que el script finalice, reinicia tu sistema para que todos los cambios surtan efecto.
    ```bash
    reboot
    ```
    ¡Disfruta de tu sistema completamente configurado!

## Configuraciones Incluidas

Cada uno de estos directorios representa un "paquete" de Stow que gestiona configuraciones en `~/.config/` o `~/`.
- **`fastfetch/`**, **`hypr/`**, **`kitty/`**, **`nvim/`**, **`ohmyzsh/`**, **`rofi/`**, **`swaylock/`**, **`swaync/`**, **`wal/`**, **`waybar/`**, **`zsh/`**, etc.
