#!/bin/bash

# A script to update the system theme using Pywal and Hyprpaper

# Check if a wallpaper path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH="$1"

# --- Pywal and Oomox ---
# Run Pywal to generate the color scheme from the new wallpaper
wal -q -n -i "$WALLPAPER_PATH"

# Apply the generated Pywal theme with oomox-cli
oomox-cli -o pywal ~/.cache/wal/colors-oomox

# --- Hyprpaper Integration ---
# Preload the new wallpaper into hyprpaper's memory for a smooth transition
hyprctl hyprpaper preload "$WALLPAPER_PATH"

# Set the preloaded wallpaper as the active wallpaper for all monitors
hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"

# --- Reload Applications ---
# Reload Hyprland to apply theme changes like border colors
hyprctl reload

echo "Wallpaper and theme updated successfully!"
