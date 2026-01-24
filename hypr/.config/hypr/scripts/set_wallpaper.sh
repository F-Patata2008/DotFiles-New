#!/bin/bash

# --- ENV FIX ---
# Ensure the script has the necessary paths even without a terminal
export PATH="${PATH}:$HOME/.local/bin:/usr/local/bin:/usr/bin"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH=$(realpath "$1")
CONF_DIR="$HOME/.config/hypr"
HYPRPAPER_CONF="$CONF_DIR/hyprpaper.conf"

# --- 1. PERSISTENCE ---
cat > "$HYPRPAPER_CONF" <<EOL
wallpaper {
    monitor = eDP-1
    path = $WALLPAPER_PATH
}
EOL

# --- 2. HYPRPAPER ---
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper -c "$HYPRPAPER_CONF" &
    sleep 0.5
else
    hyprctl hyprpaper preload "$WALLPAPER_PATH"
    hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"
fi

# --- 3. PYWAL ---
wal -n -s -t -i "$WALLPAPER_PATH"

if [ $? -ne 0 ]; then
    notify-send "Error" "Pywal failed."
    exit 1
fi

# --- 4. RELOAD EVERYTHING ---

# A) SwayNC & Waybar
swaync-client --reload-css
swaync-client -rs
killall -SIGUSR2 waybar
killall -SIGUSR1 kitty

# B) THE SWAYOSD FIX (Kill, Wait, Revive)
echo "Restarting SwayOSD..."

# Kill it
pkill swayosd-server
pkill swayosd-libinput-backend

# WAIT LOOP: Wait until it is truly dead
# This prevents the "Name already taken" error
while pgrep -x swayosd-server >/dev/null; do
    sleep 0.1
done

# Start it detached from this script so it doesn't die when script ends
# redirect output to /dev/null so it doesn't spam
nohup swayosd-server >/dev/null 2>&1 &

# Optional: Input backend (if you need it for caps lock LEDs etc)
nohup swayosd-libinput-backend >/dev/null 2>&1 &

# E) Spicetify
if command -v pywal-spicetify &> /dev/null; then
    pywal-spicetify Sleek > /dev/null 2>&1
    spicetify apply -q -n > /dev/null 2>&1
fi

notify-send -i "$WALLPAPER_PATH" "Theme Updated" "Everything synced successfully."
