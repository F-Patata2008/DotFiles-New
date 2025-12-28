# 🚀 Configuración de Zsh (con Oh My Zsh + Powerlevel10k)

![Zsh](https://img.shields.io/badge/Shell-Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)
![Oh My Zsh](https://img.shields.io/badge/Framework-Oh_My_Zsh-52C5D6?style=for-the-badge)
![Powerlevel10k](https://img.shields.io/badge/Prompt-Powerlevel10k-8A2BE2?style=for-the-badge)

Esta es mi configuración personal de Zsh, diseñada para una experiencia de terminal rápida, visualmente atractiva e increíblemente funcional. Utiliza **Oh My Zsh** como framework base y **Powerlevel10k** como tema de prompt para un rendimiento y personalización de primer nivel.

## ✨ Filosofía
- **Modularidad:** Las configuraciones personalizadas (alias y atajos) están separadas en archivos individuales dentro de `~/.zsh/custom/` para mantener el `.zshrc` principal limpio.
- **Rendimiento:** Aunque se usan plugins, la configuración está optimizada para ser rápida. El `instant prompt` de Powerlevel10k está deshabilitado para evitar conflictos.
- **Eficiencia:** Incluye una serie de alias y una función `nv()` personalizada que mejoran significativamente el flujo de trabajo diario en la terminal.

## 📂 Estructura de Archivos (Gestionada con Stow)

El comando `stow zsh` crea enlaces simbólicos a estos archivos en el directorio `~`.

```
zsh/
├── .p10k.zsh               # Configuración de apariencia de Powerlevel10k (generado por `p10k configure`).
├── .zshrc                  # Archivo principal. Carga Oh My Zsh, plugins y configuraciones personalizadas.
└── .zsh/
    └── custom/
        ├── aliases.zsh     # Mis alias personales para comandos comunes.
        └── shorcuts.zsh    # Atajos de directorios (variable-based, mal escrito a propósito).
```
*   **`.zshrc`**: Es el punto de entrada. Su trabajo es cargar el framework, los plugins y luego cualquier archivo `.zsh` que encuentre en `~/.zsh/custom/`.
*   **`.p10k.zsh`**: Controla CADA aspecto visual del prompt: iconos, colores, separadores, etc.
*   **`.zsh/custom/`**: Esta carpeta contiene mis personalizaciones para no "ensuciar" el `.zshrc` principal.

## 🛠️ Plugins y Herramientas

Esta configuración depende de los siguientes plugins de Oh My Zsh:

- `git`: Proporciona alias y funciones útiles para Git.
- `colored-man-pages`: Colorea las páginas del manual.
- `command-not-found`: Sugiere qué paquete instalar si un comando no se encuentra.
- `cp`: Muestra una barra de progreso al copiar archivos grandes.
- `archlinux`: Agrega alias útiles para `pacman`.
- `autojump`: Permite saltar a directorios frecuentes con `j <nombre>`.
- `zsh-autosuggestions`: Sugiere comandos basados en tu historial mientras escribes.
- `zsh-syntax-highlighting`: Colorea los comandos en la terminal para evitar errores de sintaxis.

## ⚡ Funciones y Alias Destacados

- **Función `nv()`:**
  - `nv`: Abre Neovim en el directorio actual (`nvim .`).
  - `nv <archivo>`: Abre el archivo especificado con Neovim (`nvim <archivo>`).
- **`please`**: Repite el último comando con `sudo`.
- **`update`**: Ejecuta mi script de actualización del sistema.
- **`set-performance`, `set-balanced`, `set-powersave`**: Alias para cambiar rápidamente los perfiles de energía de la CPU.
- **Atajos de Directorios:** Variables para acceder rápidamente a carpetas de proyectos de la universidad y programación.

---
*"La terminal es el IDE más potente que existe."*
