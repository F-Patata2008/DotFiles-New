#!/bin/bash

# --- DIRECTORIOS ---
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
RECORDING_DIR="$HOME/Videos/Recordings"
mkdir -p "$SCREENSHOT_DIR"
mkdir -p "$RECORDING_DIR"

# --- LÓGICA DE GRABACIÓN ---
if pgrep -x "wf-recorder" > /dev/null; then
    # Si wf-recorder está corriendo, solo mostramos la opción de detener.
    choice=$(echo -e " Detener Grabación" | rofi -dmenu -i -p "Grabación en curso")

    if [ "$choice" = " Detener Grabación" ]; then
        # -l SIGINT envía una señal de "parada limpia"
        pkill -l SIGINT wf-recorder
        notify-send "Grabación Detenida" "El video se ha guardado en $RECORDING_DIR"
    fi
    exit 0
fi

# --- SI NO ESTÁ GRABANDO, MOSTRAMOS EL MENÚ COMPLETO ---

# Nombres de archivo con timestamp
SCREENSHOT_FILE="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
RECORDING_FILE="recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
SCREENSHOT_PATH="$SCREENSHOT_DIR/$SCREENSHOT_FILE"
RECORDING_PATH="$RECORDING_DIR/$RECORDING_FILE"

# Opciones para Rofi (con separadores visuales)
options="🖼️ CAPTURA DE PANTALLA\n󰹑 Pantalla Completa\n󰆞 Seleccionar Área\n󰖵 Ventana Activa\n\n📹 GRABAR VIDEO\n Grabar Área\n⏺️ Grabar Pantalla Completa"

# Preguntar al usuario con Rofi
choice=$(echo -e "$options" | rofi -dmenu -i -p "Centro de Captura")

# Lógica del menú
case "$choice" in
    # --- Capturas de Pantalla ---
    "󰹑 Pantalla Completa")
        hyprshot -m output -o "$SCREENSHOT_DIR" -f "$SCREENSHOT_FILE"
        ;;
    "󰆞 Seleccionar Área")
        hyprshot -m region -o "$SCREENSHOT_DIR" -f "$SCREENSHOT_FILE"
        ;;
    "󰖵 Ventana Activa")
        hyprshot -m window -o "$SCREENSHOT_DIR" -f "$SCREENSHOT_FILE"
        ;;

    # --- Grabación de Video ---
    " Grabar Área")
        notify-send "Grabando Área" "Selecciona el área. La grabación comenzará al soltar."
        wf-recorder -g "$(slurp)" -f "$RECORDING_PATH" --audio &
        notify-send "🔴 ¡GRABANDO!" "Presiona [PrintScreen] de nuevo y elige 'Detener Grabación'."
        ;;
    "⏺️ Grabar Pantalla Completa")
        monitor=$(hyprctl monitors -j | jq -r '.[].name' | rofi -dmenu -i -p "Selecciona un monitor")
        if [ -n "$monitor" ]; then
            notify-send "🔴 ¡GRABANDO!" "Grabando $monitor. Presiona [PrintScreen] y 'Detener'."
            wf-recorder -o "$monitor" -f "$RECORDING_PATH" --audio &
        else
            notify-send "Grabación cancelada."
        fi
        ;;
    *)
        # Si se presiona Escape
        exit 1
        ;;
esac
