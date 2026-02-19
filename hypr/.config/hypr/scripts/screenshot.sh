#!/bin/bash

# --- CONFIG & DIRECTORIES ---
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
RECORDING_DIR="$HOME/Videos/Recordings"
mkdir -p "$SCREENSHOT_DIR" "$RECORDING_DIR"

# Nombres de archivo
TS=$(date +'%Y-%m-%d_%H-%M-%S')
SCREENSHOT_PATH="$SCREENSHOT_DIR/screenshot_$TS.png"
RECORDING_PATH="$RECORDING_DIR/recording_$TS.mp4"

# Noctalia IPC (Para notificaciones o triggers)
IPC="qs -c noctalia-shell ipc call"

# --- LÓGICA DE GRABACIÓN (DETENER) ---
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -l SIGINT wf-recorder
    notify-send -a "System" " Grabación Detenida" "Video guardado en $RECORDING_DIR"
    exit 0
fi

# --- MENÚ (Usando FUZZEL para velocidad instantánea) ---
# Si no tienes fuzzel: sudo pacman -S fuzzel
options="🖼️  Pantalla Completa\n󰆞  Seleccionar Área\n󰖵  Ventana Activa\n  Grabar Área\n⏺️  Grabar Pantalla Completa"

choice=$(echo -e "$options" | fuzzel -d -p "󰄀 Centro de Captura: " --width 30)

case "$choice" in
    "🖼️  Pantalla Completa")
        hyprshot -m output -o "$SCREENSHOT_DIR" -f "screenshot_$TS.png"
        ;;
    "󰆞  Seleccionar Área")
        hyprshot -m region -o "$SCREENSHOT_DIR" -f "screenshot_$TS.png"
        ;;
    "󰖵  Ventana Activa")
        hyprshot -m window -o "$SCREENSHOT_DIR" -f "screenshot_$TS.png"
        ;;
    "  Grabar Área")
        notify-send -a "System" "🔴 Selecciona Área" "La grabación comenzará al soltar."
        wf-recorder -g "$(slurp)" -f "$RECORDING_PATH" --audio &
        ;;
    "⏺️  Grabar Pantalla Completa")
        # Detecta automáticamente el monitor activo para evitar otro menú
        MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
        notify-send -a "System" "🔴 Grabando Pantalla" "Monitor: $MONITOR"
        wf-recorder -o "$MONITOR" -f "$RECORDING_PATH" --audio &
        ;;
    *)
        exit 1
        ;;
esac
