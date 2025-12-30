#!/bin/bash

# ==============================================================================
# ROFI WALLPAPER SELECTOR (V6.0 - Theme File Edition)
# ==============================================================================

# --- CONFIGURACIÓN ---
WALLPAPER_DIR="$HOME/Dotfiles/Wallpapers"
SET_WALLPAPER_SCRIPT="$HOME/.config/hypr/scripts/set_wallpaper.sh"

# --- LÓGICA DEL SCRIPT ---

# Buscamos los archivos y se los pasamos a Rofi, que ahora usará nuestro tema dedicado.
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | \
                    sort | \
                    rofi -dmenu -i -p ' Wallpaper' -theme ~/.config/rofi/grid.rasi)

# Si el usuario seleccionó un archivo, Rofi devuelve la ruta completa.
if [ -n "$SELECTED_WALLPAPER" ]; then
    "$SET_WALLPAPER_SCRIPT" "$SELECTED_WALLPAPER"
fi
