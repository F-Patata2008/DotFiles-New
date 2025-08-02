#!/bin/bash

# Check if a wallpaper path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper"
    exit 1
fi

WALLPAPER_PATH="$1"

# Run Pywal to generate and set the color scheme
# -i specifies the input image
# -n skips setting the wallpaper in the terminal (we use swaybg)
# -q runs quietly
wal -q -n -i "$WALLPAPER_PATH"

# Set the wallpaper using swaybg
# -i specifies the input image
# -m specifies the scaling mode (fill, fit, stretch, etc.)
swaybg -i "$WALLPAPER_PATH" -m fill &
oomox-cli -o pywal ~/.cache/wal/colors-oomox
# Reload running applications to apply the new theme
hyprctl reload

echo "Wallpaper and theme updated successfully!"
