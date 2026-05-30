#!/bin/bash

# 1. Definir rutas (OJO AQUI)
# La carpeta donde estan las imagenes
WALL_DIR="$HOME/Dotfiles/Wallpapers"

# La ruta exacta de tu script que aplica el fondo (EL PRIMERO QUE ME MOSTRASTE)
# Si lo tienes en otra parte, cambia esta linea.
SETTER_SCRIPT="$HOME/Dotfiles/hypr/.config/hypr/scripts/set_wallpaper.sh"
# ^^^ REVISA QUE ESTA RUTA SEA REAL. Si no sabes donde está, usa `find ~/Dotfiles -name set_Wallpaper.sh` para buscarlo.

# 2. Comprobar dependencias
if ! command -v fzf &> /dev/null; then
    echo "Error: fzf no está instalado. Ejecuta 'sudo pacman -S fzf'"
    exit 1
fi

# 3. Comando de previsualización para Kitty
# place=ANCHO x ALTO @ POS_X x POS_Y
# Ajusta el 60x60 si la imagen se ve chica o muy grande
PREVIEW_CMD="kitten icat --clear --transfer-mode=memory --stdin=no --place=60x60@30x5 {}"

# 4. Buscar imágenes recursivamente (entra a Gundam y Macross)
# Usamos 'find' para listar todo y 'fzf' para elegir
SELECTED=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | \
    fzf --preview "$PREVIEW_CMD" \
        --preview-window=right:50% \
        --prompt="Fondo > " \
        --height=100% \
        --layout=reverse \
        --border \
        --margin=1 \
        --padding=1)

# 5. Si elegiste algo, aplicar
if [ -n "$SELECTED" ]; then
    notify-send "Fondo seleccionado:" "$SELECTED"

    if [ -f "$SETTER_SCRIPT" ]; then
        bash "$SETTER_SCRIPT" "$SELECTED"
    else
        notify-send "ERROR CRITICO:" "No encuentro el script set_Wallpaper.sh en: $SETTER_SCRIPT Por favor edita este archivo y corrige la ruta SETTER_SCRIPT."
        read -p "Presiona enter para salir..."
    fi
fi
