# 🎨 Configuración de Sway Notification Center (SwayNC)

![SwayNC](https://img.shields.io/badge/Notifications-SwayNC-88C0D0?style=for-the-badge)
![CSS](https://img.shields.io/badge/Styling-CSS_&_Pywal-56B6C2?style=for-the-badge&logo=css3&logoColor=white)

Esta es mi configuración para `SwayNC`, que lo transforma de un simple demonio de notificaciones a un **Centro de Control** interactivo y visualmente cohesivo, anclado en la parte superior de la pantalla.

## ✨ Filosofía
- **Funcionalidad Dual:** Sirve tanto para mostrar notificaciones emergentes como para actuar de panel de control rápido, accesible a través de un clic en Waybar.
- **Integración con Pywal:** El `style.css` importa directamente la paleta de colores de `pywal`, asegurando que la apariencia del centro de control y las notificaciones siempre haga juego con el fondo de pantalla.
- **Acceso Rápido:** El `buttons-grid` está configurado con acciones de sistema comunes, permitiendo controlar aspectos clave del PC sin necesidad de abrir una terminal o un menú completo.

## 📂 Estructura de Archivos

- **`config.json`**: Define la **lógica y el layout** del centro de control.
  - `positionX` y `positionY`: Lo anclan en la parte superior central de la pantalla.
  - `widgets`: Define el orden de los elementos: Título, control de medios (MPRIS), cuadrícula de botones, "No Molestar" (DND) y la lista de notificaciones.
  - `widget-config`: Configura cada widget individualmente. Lo más destacado es `buttons-grid`, que mapea íconos a scripts y comandos.

- **`style.css`**: Controla toda la **apariencia visual**.
  - `@import`: Importa `colors-waybar.css` desde la caché de `pywal` para usar variables de color dinámicas (`@background`, `@foreground`, etc.).
  - **Estilo Cohesivo:** El diseño de los widgets, botones y notificaciones imita el estilo de la Waybar (fondos semi-transparentes, bordes redondeados) para crear una experiencia de usuario unificada.

## 🛠️ Centro de Control (`buttons-grid`)

El corazón de esta configuración es la cuadrícula de botones, que proporciona los siguientes atajos:

| Icono | Comando                                | Descripción                        |
| :---: | -------------------------------------- | ---------------------------------- |
| ``   | `.../scripts/wifi.sh`                  | Abre el menú de redes Wi-Fi (Rofi).|
| ``   | `blueman-manager`                      | Abre el gestor de Bluetooth.       |
| `󰈙`   | `nautilus`                             | Lanza el gestor de archivos.       |
| `󰻠`   | `gnome-system-monitor`                 | Abre el monitor del sistema.       |
| ``   | `hyprlock`    | Bloquea la pantalla.               |
| `󰜉`   | `reboot`                               | Reinicia el sistema.               |
| `⏻`   | `systemctl hibernate`                  | Hiberna el sistema.                |


## 🚀 Integración con Waybar

La interacción con `SwayNC` se maneja desde el módulo `custom/notification` en la configuración de Waybar:
- **`exec`:** `swaync-client -swb` obtiene el estado de las notificaciones para mostrar el ícono correcto en la barra.
- **`on-click`:** `swaync-client -t -sw` abre y cierra el centro de control.
- **`on-click-right`:** `swaync-client -d -sw` abre y cierra el modo "No Molestar".
