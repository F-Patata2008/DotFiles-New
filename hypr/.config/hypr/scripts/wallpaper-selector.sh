#!/bin/bash

# Directorio de tus wallpapers
WALLPAPER_DIR="$HOME/Dotfiles/Wallpapers"

# ----------------------------------------------------------------------
# NO EDITES MÁS ABAJO A MENOS QUE SEPAS LO QUE HACES
# ----------------------------------------------------------------------

# Script de Rofi para mostrar vista previa de imágenes
# Fuente: https://github.com/adi1090x/rofi (adaptado)
rofi_command="rofi -dmenu -i -p 'Select Wallpaper'"

# 1. Obtener la lista de archivos de imagen en el directorio
# Usamos 'find' para buscar recursivamente en Gundam, Macross, etc.
files=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \))

# 2. Generar el menú para Rofi
# Cada línea tendrá un texto (nombre del archivo) y un metadato de icono
menu() {
    for file in $files; do
        # Mostramos la ruta relativa desde 'Wallpapers/' para que sea más corta
        # Y le decimos a Rofi que use el path completo como el icono
        echo -e "$(basename "$file")\x00icon\x1f$file"
    done
}

# 3. Lanzar Rofi
# -show-icons: Habilita la vista previa de iconos
# -theme-str '...': Un tema temporal para decirle a Rofi cómo mostrar la imagen
chosen_line=$(menu | $rofi_command -show-icons -theme-str '
    #window {
        width: 60%;
        height: 70%;
    }
    listview {
        columns: 2; /* 2 columnas: imagen a la izquierda, texto a la derecha */
    }
    element {
        orientation: vertical; /* La imagen arriba, el texto abajo */
    }
    element-icon {
        size: 200px; /* Tamaño de la vista previa */
    }
    element-text {
        horizontal-align: 0.5; /* Centrar el nombre del archivo */
    }
')

# 4. Procesar la selección
if [ -n "$chosen_line" ]; then
    # Como usamos el path completo como icono, Rofi devuelve el path al seleccionarlo
    # (El texto que vemos es solo visual, lo que importa es el metadato del icono)
    
    # Buscamos la línea en nuestra lista de archivos que coincida con el basename seleccionado
    selected_wallpaper=$(find "$WALLPAPER_DIR" -type f -name "$chosen_line")

    if [ -n "$selected_wallpaper" ]; then
        # Ejecutar tu script principal con el wallpaper seleccionado
        ~/.config/hypr/scripts/set_wallpaper.sh "$selected_wallpaper"
    else
        notify-send "Error" "No se pudo encontrar el wallpaper seleccionado."
    fi
fi
