# 🚪 Configuración de Wlogout (Menú de Salida para Hyprland)

![Wlogout](https://img.shields.io/badge/Logout_Menu-Wlogout-BF616A?style=for-the-badge)
![CSS](https://img.shields.io/badge/Styling-CSS-56B6C2?style=for-the-badge&logo=css3&logoColor=white)

Esta configuración transforma `wlogout` en un menú de salida elegante y moderno, diseñado para complementar un entorno de Hyprland. Se invoca a través de un script de shell que calcula dinámicamente el tamaño y los estilos para adaptarse a cualquier resolución de pantalla.

## ✨ Características

- **Diseño "Frosted Glass":** Los botones utilizan un fondo semi-transparente que, combinado con la regla de `blur` en Hyprland, crea un efecto de vidrio esmerilado sobre el fondo de pantalla.
- **Layout Adaptativo:** El script `loguot.sh` detecta la resolución del monitor y la escala de Hyprland, y ajusta los márgenes (`${mgn}`) de los botones para que siempre se vean bien.
- **Animación de Foco ("Grow Effect"):** El botón seleccionado se expande suavemente (`button:focus`), proporcionando un feedback visual claro y satisfactorio.
- **Integración con `hyprlock`:** El botón de bloqueo verifica si la pantalla ya está bloqueada antes de intentar bloquearla de nuevo.

## 📂 Estructura de Archivos

- **`layout`**: Un archivo JSON que define los botones, sus etiquetas, los comandos que ejecutan (`action`) y sus atajos de teclado (`keybind`).
  - **Acciones:** `systemctl poweroff`, `systemctl reboot`, `loginctl terminate-user`, etc.

- **`style.css`**: El archivo de estilos que controla toda la apariencia visual.
  - **Variables Dinámicas:** Utiliza variables como `${mgn}` y `${hvr}` que son reemplazadas al vuelo por el script `loguot.sh` para lograr el diseño adaptativo.
  - **Efectos de Transición:** Define las animaciones `cubic-bezier` para los efectos de hover y focus.

## 🚀 Cómo Funciona

Esta configuración no se lanza directamente. Se invoca a través del script `~/Dotfiles/hypr/.config/hypr/scripts/loguot.sh`.

El script realiza los siguientes pasos:
1.  **Detecta el Entorno:** Obtiene la resolución y escala del monitor activo usando `hyprctl`.
2.  **Calcula Variables de Estilo:** Basado en la resolución, calcula los valores para los márgenes (`mgn`, `hvr`) y el tamaño de la fuente (`fntSize`).
3.  **Inyecta las Variables en el CSS:** Utiliza `envsubst` para reemplazar las variables en una copia temporal del `style.css`.
4.  **Lanza Wlogout:** Ejecuta `wlogout` y le pasa el CSS procesado a través de una tubería (`pipe`), aplicando el tema dinámico.

Este método permite tener un menú de salida que se ve perfecto en cualquier pantalla, sin necesidad de tener múltiples archivos de CSS o valores fijos.
