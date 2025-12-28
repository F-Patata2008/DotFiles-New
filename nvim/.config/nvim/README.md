# 🐧 Configuración de Neovim para Programación Competitiva y Desarrollo General

![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Lazy.nvim](https://img.shields.io/badge/Plugin_Manager-Lazy.nvim-blue?style=for-the-badge)

Esta es mi configuración personal de Neovim, construida desde cero en Lua. Está diseñada para ser un IDE ligero y potente, con un enfoque especial en **C++ para Programación Competitiva**, desarrollo en **LaTeX** para la universidad y un entorno de scripting general para **Linux**.

## ✨ Filosofía
- **Modularidad:** Toda la configuración está dividida en archivos pequeños y cohesivos dentro de la carpeta `lua/`.
- **Carga Perezosa (Lazy Loading):** Se utiliza `lazy.nvim` para cargar plugins solo cuando son necesarios, garantizando un tiempo de inicio casi instantáneo.
- **Centrado en el Teclado:** Atajos de teclado (`keybinds`) optimizados para no tener que tocar el mouse.
- **"Baterías Incluidas":** Configuración completa para LSP, autocompletado, snippets, debugging y formato de código.

## 📂 Estructura de la Configuración

La configuración sigue una estructura moderna y fácil de mantener:

```
nvim/
├── init.lua          # Punto de entrada principal, carga Lazy.nvim y los módulos.
└── lua/
    ├── core/         # Configuraciones base de Neovim (opciones, atajos).
    │   ├── autostart.lua
    │   ├── current-theme.lua
    │   └── keybinds.lua
    ├── plugins/      # Cada archivo es una "spec" de Lazy para un plugin.
    └── snippets/     # Snippets personalizados para LuaSnip.
        ├── cpp.lua
        └── tex.lua
```

## 🌟 Características y Plugins Clave

| Característica         | Plugins Utilizados                                                                    |
| ---------------------- | ------------------------------------------------------------------------------------- |
| **Gestor de Plugins**  | `folke/lazy.nvim`                                                                     |
| **Autocompletado**     | `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, `onsails/lspkind.nvim`                          |
| **Soporte LSP**        | `neovim/nvim-lspconfig`, `williamboman/mason.nvim`, `j-hui/fidget.nvim`                 |
| **Navegación**         | `nvim-telescope/telescope.nvim`, `nvim-neo-tree/neo-tree.nvim`                        |
| **Interfaz (UI)**      | `goolord/alpha-nvim`, `nvim-lualine/lualine.nvim`, `catppuccin/nvim`, `folke/tokyonight.nvim` |
| **Edición de Código**  | `nvim-treesitter/nvim-treesitter`, `windwp/nvim-autopairs`, `kylechui/nvim-surround`   |
| **Debugging**          | `mfussenegger/nvim-dap` y `rcarriga/nvim-dap-ui` (configurado para GDB en C++)          |
| **Formato**            | `mhartington/formatter.nvim` (con `clang-format`, `stylua`, `black`, `prettier`)      |
| **Git**                | `lewis6991/gitsigns.nvim`                                                             |
| **Lenguajes Específicos**| `lervag/vimtex` (LaTeX), `yuukiflow/Arduino-Nvim` (Arduino), `GCBallesteros/jupytext.nvim` (Jupyter) |
| **Utilidades de IA**   | `zbirenbaum/copilot.lua` y `CopilotChat.nvim`                                         |

## ⌨️ Atajos Esenciales

La tecla `<leader>` está mapeada a `Espacio`.

| Atajo               | Acción                                             |
| ------------------- | -------------------------------------------------- |
| `<C-n>`             | Abrir/Cerrar el explorador de archivos (`Neo-tree`)  |
| `<C-f>`             | Buscar texto en todo el proyecto (`Telescope`)       |
| `gd`                | Ir a la definición (LSP)                           |
| `gr`                | Buscar referencias (LSP)                            |
| `<leader>ca`        | Ver acciones de código disponibles (LSP)             |
| `<leader>gf`        | Formatear el buffer actual (`formatter.nvim`)        |
| `<leader>xx`        | Mostrar/Ocultar lista de errores (`trouble.nvim`)    |
| `<C-c>`             | Abrir chat con Copilot                             |

---
*Hecho para maximizar la velocidad y minimizar las distracciones.*
