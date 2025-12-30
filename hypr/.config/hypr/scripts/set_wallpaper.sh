#!/bin/bash

# A script to update the system theme using Pywal and Hyprpaper

# 1. Validar que pasaron un archivo
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH="$1"
echo "Changing wallpaper to: $WALLPAPER_PATH"

# --- 1. HYPRPAPER (LO PRIMERO: FEEDBACK VISUAL INMEDIATO) ---
# Verificamos si hyprpaper esta corriendo, si no, lo lanzamos
if ! pgrep -x "hyprpaper" > /dev/null; then
    echo "Hyprpaper no estaba corriendo, iniciandolo..."
    hyprpaper &
    sleep 1 # Le damos un segundito para respirar
fi

# El truco: Limpiar antes de cargar para evitar errores de cache o memoria
hyprctl hyprpaper unload all

# Cargar la imagen nueva en RAM
hyprctl hyprpaper preload "$WALLPAPER_PATH"

# Aplicarla a todos los monitores (la coma vacía significa "todos")
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"

# --- 2. PYWAL (Generar paleta de colores) ---
# Generamos los colores en silencio (-q) y sin setear el fondo por backend (-n)
wal -q -n -i "$WALLPAPER_PATH"

# --- 3. RECARGAR APPS LIGERA (Waybar, SwayNC) ---
# Recargamos Hyprland para bordes
hyprctl reload

# Recargamos notificaciones y waybar para que tomen los colores nuevos rapido
swaync-client -rs
swaync-client --reload-css
# Si usas waybar con colores de pywal, reiniciala:
# killall waybar; waybar &  <-- Descomenta si waybar no actualiza color sola

# --- 4. OOMOX (LA PARTE LENTA) ---
# Tiramos esto al final y en segundo plano (&) para que no sientas lag
# Esto compila el tema GTK/Iconos

pkill oomox-cli || true
notify-send "Compilando Tema" "Generando tema GTK con Oomox (esto demora)..."
(
oomox-cli -o pywal ~/.cache/wal/colors-oomox > /dev/null 2>&1

notify-send "Wallpaper cambiado" "el tema GTK se aplicará en unos segundos."
) &
