#!/bin/bash

# =============================================================================
# SCRIPT DE TEMATIZACIÓN DINÁMICA (Hyprland v0.53+)
# =============================================================================

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH=$(realpath "$1")
THEME_NAME="pywal" # Nombre consistente para evitar confusiones

echo "🚀 Iniciando cambio de tema: $WALLPAPER_PATH"

# --- 1. HYPRPAPER (Arreglo de errores de IPC) ---
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    sleep 1
fi

# Intentar aplicar wallpaper (silenciamos errores por si el IPC tarda en despertar)
hyprctl hyprpaper unload all > /dev/null 2>&1
hyprctl hyprpaper preload "$WALLPAPER_PATH" > /dev/null 2>&1
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH" > /dev/null 2>&1

# --- 2. PYWAL (Generar paleta) ---
wal -q -n -i "$WALLPAPER_PATH"
source "$HOME/.cache/wal/colors.sh" # Cargar variables para usar en el script

# --- 3. RECARGAR INTERFAZ ---
hyprctl reload
swaync-client -rs > /dev/null 2>&1
swaync-client --reload-css > /dev/null 2>&1
killall -SIGUSR2 waybar # Recarga configuración de Waybar sin cerrarla

# --- 4. CONFIGURACIÓN GLOBAL DE MODO OSCURO (Importante para GTK) ---
# Esto quita las barras blancas de las cabeceras
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-color-scheme 'prefer-dark'

# --- 5. OOMOX & GTK SYNC (Segundo plano para no bloquear) ---
notify-send -i "$WALLPAPER_PATH" "Tematización" "Generando paleta GTK..."

(
    # Eliminar procesos previos de oomox para no saturar
    pkill oomox-cli || true

    # Compilar el tema con oomox
    oomox-cli -o "$THEME_NAME" ~/.cache/wal/colors-oomox > /dev/null 2>&1

    # APLICAR EL TEMA (Esto es lo que te faltaba)
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"

    # FIX PARA GTK4 / LIBADWAITA (Pavucontrol, Blueman, etc.)
    # Enlazamos el CSS generado directamente a la carpeta de configuración de GTK4
    mkdir -p "$HOME/.config/gtk-4.0"
    ln -sf "$HOME/.themes/$THEME_NAME/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"
    ln -sf "$HOME/.themes/$THEME_NAME/gtk-4.0/gtk-dark.css" "$HOME/.config/gtk-4.0/gtk-dark.css"
    ln -sf "$HOME/.themes/$THEME_NAME/gtk-4.0/assets" "$HOME/.config/gtk-4.0/assets"

    notify-send -i "$WALLPAPER_PATH" "Sistema Actualizado" "Tema GTK y colores aplicados correctamente."
    echo "✅ Todo listo. Tema '$THEME_NAME' aplicado."
) &
