#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Find a random wallpaper from the directory
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Set the wallpaper using our main script
~/.config/hypr/scripts/set_wallpaper.sh "$RANDOM_WALLPAPER"
