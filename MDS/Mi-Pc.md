# 💻 Mi Setup: "Saviour-Arch" en un Lenovo E41-55

Este documento detalla la configuración de hardware y software de mi máquina principal, un setup minimalista y altamente optimizado basado en Arch Linux y Hyprland.

## Hardware Specifications

| Componente         | Especificación                                      |
| ------------------ | --------------------------------------------------- |
| **Modelo**         | Lenovo E41-55                                       |
| **Procesador**     | AMD Ryzen 3 3250U (2 Cores, 4 Threads @ 2.60 GHz)   |
| **Gráficos**       | AMD Radeon Vega 3 (Integrada)                       |
| **Memoria RAM**    | 16 GB DDR4 3200MHz (2x8 GB)                         |
| **Almacenamiento** | 500 GB NVMe Gen 3 SSD (WD Black)                    |
| **Pantalla**       | 14" 1366x768 @ 60 Hz                                |
| **Lector Huellas** | Goodix `27c6:55b4`                                  |

## 💾 Estructura de Particionado (LVM sobre GPT)

El sistema utiliza **LVM (Logical Volume Management)** para una gestión de disco flexible y escalable, permitiendo redimensionar particiones sin esfuerzo.

```plaintext
nvme0n1 (465.8G)
├─ nvme0n1p1 (1G, ext4)  -> /boot (Partición EFI)
└─ nvme0n1p2 (464.8G)    -> LVM Physical Volume
   ├─ ssdm2-swap (24G)      -> [SWAP]
   ├─ ssdm2-arch--root (48.8G) -> / (Arch Linux)
   ├─ ssdm2-linux--home (344G) -> /home (Arch Linux)
   └─ ssdm2-zorin (48G)       -> / (Zorin OS - Fallback)
```

## 🐧 Stack de Software y Filosofía

Mi entorno está construido sobre la filosofía "hágalo usted mismo" de Arch. No utilizo un Entorno de Escritorio completo (DE); en su lugar, he ensamblado un sistema a partir de componentes de Wayland que se ajustan a mi flujo de trabajo, con un fuerte enfoque en la eficiencia y la personalización dinámica.

- **Compositor y UI:**
  - **Hyprland:** Como compositor principal, aprovechando sus animaciones fluidas y su extensa configuración.
  - **Waybar & Rofi:** Para la barra de estado y el lanzador de aplicaciones, ambos con temas dinámicos.
  - **SDDM:** Como Display Manager, con un tema personalizado para una experiencia de login cohesiva.
  - **Aplicaciones GTK:** Utilizo una selección curada de aplicaciones de GNOME (como Nautilus) por su funcionalidad, temadas con `oomox` para que coincidan con el resto del sistema.

- **Theming y Estética:**
  - **Pywal:** Es el cerebro del theming. Todo el sistema, desde la terminal hasta la barra, adapta sus colores al fondo de pantalla actual.
  - **Temas de Arranque:** GRUB (`minegrub`) y Plymouth (`minecraft-theme`) están personalizados para una experiencia de arranque única.

- **Integración y Productividad:**
  - **KDE Connect:** Para la integración total con mi dispositivo móvil. A pesar de algunos problemas con el montaje de archivos en Nautilus, la funcionalidad de notificaciones y control remoto es indispensable.
  - **Gestión de Energía:** El sistema está optimizado para la portabilidad, utilizando `tlp` para perfiles de energía, `hypridle` para la inactividad, y `systemctl hibernate` para una suspensión profunda que preserva la batería.

- **Gestión de Configuración:**
  - **Dotfiles + Stow:** Todas las configuraciones residen en este repositorio de GitHub y son desplegadas mediante enlaces simbólicos con GNU Stow, garantizando una configuración 100% reproducible.

## 🚧 Desafíos y Mejoras Pendientes

- **KDE Connect:**
  - El montaje de archivos (filesystem) solo funciona correctamente en Dolphin, no en Nautilus (un problema conocido de GVFS).
  - El script de batería del teléfono en Waybar actualmente no puede detectar si el dispositivo está cargando.
- **Migración de Navegador:** Planeo migrar de Opera a un navegador más ligero como **Zen Browser** para reducir el consumo de recursos.
