==================================================================
 DUMP DE CONFIGURACIÓN: wlogout/.config/wlogout
 Fecha: Sun Jan 18 10:02:35 PM -03 2026
==================================================================


################################################################################
AR-CHIVO: wlogout/.config/wlogout/layout
################################################################################

{ "label": "lock", "action": "pidof hyprlock || hyprlock", "text": "Lock", "keybind": "l" }
{ "label": "logout", "action": "loginctl terminate-user $USER", "text": "Logout", "keybind": "e" }
{ "label": "suspend", "action": "systemctl suspend", "text": "Suspend", "keybind": "u" }
{ "label": "shutdown", "action": "systemctl poweroff", "text": "Shutdown", "keybind": "s" }
{ "label": "hibernate", "action": "systemctl hibernate", "text": "Hibernate", "keybind": "h" }
{ "label": "reboot", "action": "systemctl reboot", "text": "Reboot", "keybind": "r" }


################################################################################
AR-CHIVO: wlogout/.config/wlogout/README.md
################################################################################

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


################################################################################
AR-CHIVO: wlogout/.config/wlogout/style.css
################################################################################

* {
    background-image: none;
    transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682); /* Smooth transition from HyDE */
    font-size: 16px;
    border: none;
    box-shadow: none;
}

window {
    background-color: transparent;
}

button {
    color: #c0caf5;
    /* This semi-transparent background is what allows the blur (frost) to work */
    background-color: rgba(26, 27, 38, 0.75);
    background-repeat: no-repeat;
    background-position: center;
    background-size: 35%;
}

/* --- Frost Effect on Hover --- */
/* This ONLY changes the color. It does not grow. */
button:hover {
    background-color: rgba(65, 72, 104, 0.85); /* Lighter, frosted color */
}

/* --- Grow Effect on Focus --- */
/* This changes the color AND the margins, making the selected button bigger. */
button:focus {
    background-color: rgba(80, 88, 129, 0.9); /* A slightly more active/focused color */
    background-size: 40%;
}

/* --- Default Positioning (Seamless Bar) --- */
#lock {
    margin: ${mgn}px 0px ${mgn}px ${mgn}px;
    border-radius: 25px 0 0 25px;
}
#logout, #suspend, #shutdown, #hibernate {
    margin: ${mgn}px 0px;
    border-radius: 0;
}
#reboot {
    margin: ${mgn}px ${mgn}px ${mgn}px 0px;
    border-radius: 0 25px 25px 0;
}

/* --- Focus State Margins (The "Grow" effect) --- */
button:focus#lock {
    margin: ${hvr}px -5px ${hvr}px ${mgn}px; /* Negative margin pulls neighbors closer */
    border-radius: 25px;
}
button:focus#logout,
button:focus#suspend,
button:focus#shutdown,
button:focus#hibernate {
    margin: ${hvr}px -5px; /* Negative margin on both sides */
    border-radius: 25px;
}
button:focus#reboot {
    margin: ${hvr}px ${mgn}px ${hvr}px -5px;
    border-radius: 25px;
}

/* --- Icons --- */
#lock { background-image: image(url("/usr/share/wlogout/icons/lock.png")); }
#logout { background-image: image(url("/usr/share/wlogout/icons/logout.png")); }
#suspend { background-image: image(url("/usr/share/wlogout/icons/suspend.png")); }
#shutdown { background-image: image(url("/usr/share/wlogout/icons/shutdown.png")); }
#hibernate { background-image: image(url("/usr/share/wlogout/icons/hibernate.png")); }
#reboot { background-image: image(url("/usr/share/wlogout/icons/reboot.png")); }

