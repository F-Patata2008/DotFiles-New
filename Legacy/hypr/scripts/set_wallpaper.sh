#!/bin/bash

# --- CONFIG & IPC ---
export PATH="${PATH}:$HOME/.local/bin:/usr/local/bin:/usr/bin"
# The Noctalia IPC command
IPC="qs -c noctalia-shell ipc call"

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH=$(realpath "$1")

# --- 1. SET WALLPAPER VIA NOCTALIA ---
# This replaces hyprpaper. Noctalia handles the transition.
$IPC wallpaper set "$WALLPAPER_PATH" eDP-1

# --- 2. GENERATE COLORS WITH PYWAL ---
# -n (no wallpaper) -q (quiet) -t (skip terminal checks)
wal -n -s -t -i "$WALLPAPER_PATH"

if [ $? -ne 0 ]; then
    notify-send "Error" "Pywal failed."
    exit 1
fi

# --- 3. RELOAD KITTY ---
# Sends a signal to all open Kitty instances to reload their colors from ~/.cache/wal/colors-kitty.conf
killall -SIGUSR1 kitty

# --- 4. RELOAD NOCTALIA THEME ---
# Most Noctalia setups watch the CSS files, but this forces a reload
# to ensure the Pywal colors are applied to the bar and dashboard.
$IPC stylesheet reload

# --- 5. NOTIFICATION ---
# Uses Noctalia's own notification system
notify-send -a "System" -i "$WALLPAPER_PATH" "Theme Updated" "Noctalia, Kitty, and synced."
