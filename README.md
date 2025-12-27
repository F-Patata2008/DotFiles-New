# 🍙 Patata's Dotfiles (Hyprland Rice)

![Hyprland](https://img.shields.io/badge/WM-Hyprland-E54B83?style=for-the-badge&logo=hyperspace&logoColor=white)
![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Terminal](https://img.shields.io/badge/Terminal-Kitty-924298?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Zsh_&_P10k-yellow?style=for-the-badge&logo=powershell&logoColor=white)
![Editor](https://img.shields.io/badge/Editor-Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)

Este repositorio contiene mi configuración personal completa para un entorno de escritorio en **Arch Linux**, centrado en **Hyprland**. El objetivo es un sistema minimalista, rápido y estéticamente cohesivo, donde cada componente se adapta dinámicamente al fondo de pantalla.

Todo está gestionado con [GNU Stow](https://www.gnu.org/software/stow/) y un script de instalación maestro que automatiza el despliegue de cero a un sistema funcional.

## ✨ Características Destacadas

- **Instalación Automatizada**: Un script `install.sh` se encarga de todo: paquetes, drivers, servicios, temas y despliegue de dotfiles.
- **Theming Dinámico con Pywal**: El sistema completo (Hyprland, Waybar, Rofi, Kitty, GTK) cambia de color para hacer juego con el wallpaper.
- **Entorno Wayland Puro**: Construido sobre Hyprland y su ecosistema (`hyprlock`, `hypridle`, `hyprpaper`) para animaciones fluidas y eficiencia.
- **UI Moderna y Funcional**: `Waybar` como barra de estado, `Rofi` como lanzador y `SwayNC` para notificaciones, todo temático.
- **Soporte de Hardware Específico**:
  - **Lector de Huellas Goodix**: Instalación interactiva del driver y configuración de PAM para `sudo` y `sddm`.
  - **Optimización para Laptops**: Gestión de energía con `tlp` y `powertop` para maximizar la autonomía.
- **Arranque Personalizado**: Temas de Minecraft para GRUB (`minegrub`) y Plymouth.
- **Estructura LVM**: Particionado flexible con volúmenes lógicos para `/`, `/home` y `swap`, permitiendo una gestión de disco superior.

## 🚀 Instalación

> **Advertencia:** Este script está diseñado para mi hardware específico (Lenovo E41-55). Úsalo bajo tu propio riesgo.

El proceso asume que tienes una **instalación base de Arch Linux** con un usuario, `sudo`, `git` y conexión a internet.

1.  **Clonar el Repositorio**
    ```bash
    git clone https://github.com/F-Patata2008/DotFiles-New.git ~/Dotfiles
    cd ~/Dotfiles
    ```

2.  **Ejecutar el Instalador Maestro**
    El script `Install/install.sh` guiará todo el proceso.
    ```bash
    cd Install
    chmod +x install.sh
    ./install.sh
    ```

3.  **Reiniciar**
    Un reinicio es necesario para que todos los servicios, temas y drivers se carguen correctamente.
    ```bash
    reboot
    ```
    Al volver, deberías ser recibido por el login de SDDM temático y, tras iniciar sesión, el escritorio Hyprland completo.

## 🛠️ Stack de Software

| Componente                | Aplicación                                             |
| ------------------------- | ------------------------------------------------------ |
| **Compositor (WM)**       | `Hyprland`                                             |
| **Display Manager**       | `SDDM` (con tema personalizado)                        |
| **Barra de Estado**       | `Waybar`                                               |
| **Lanzador de Apps**      | `Rofi`                                                 |
| **Terminal**              | `Kitty`                                                |
| **Notificaciones**        | `SwayNC`                                               |
| **Gestor de Archivos**    | `Nautilus` (y otras apps de GNOME)                     |
| **Editor de Código**      | `Neovim` (configuración modular en Lua)                |
| **Theming Dinámico**      | `pywal`                                                |
| **Gestión de Energía**    | `tlp`, `hypridle`, `wlsunset`                          |
| **Bloqueo de Pantalla**   | `hyprlock`                                             |
| **Gestión de Dotfiles**   | `GNU Stow`                                             |
| **Shell**                 | `zsh` con `Oh My Zsh` y `Powerlevel10k`                |

## 💻 Mi Máquina

- **Modelo:** Lenovo E41-55
- **CPU:** AMD Ryzen 3 3250U
- **GPU:** AMD Radeon Vega 3 (Integrada)
- **RAM:** 16 GB DDR4
- **SSD:** 500 GB NVMe WD Black
- **Particionado:** LVM sobre una partición GPT, con `/boot` separado.
- **Lector de Huellas:** Goodix 27c6:55b4

---
*Hecho en Arch (BTW).*
