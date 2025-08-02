#!/bin/bash

# Directory to save screenshots
dir="$HOME/Pictures/Screenshots"
# Create the directory if it doesn't exist
mkdir -p "$dir"

# Filename for the screenshot with timestamp
file="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

# Options for Rofi menu
options="󰹑 Fullscreen\n󰆞 Area\n󰖵 Window"

# Show Rofi menu and get the user's choice
choice=$(echo -e "$options" | rofi -dmenu -i -p "Screenshot")

# Execute the command based on the choice.
# hyprshot will handle the notification, preview, and clipboard copy.
case $choice in
    "󰹑 Fullscreen")
        hyprshot -m output -o "$dir" -f "$file"
        ;;
    "󰆞 Area")
        hyprshot -m region -o "$dir" -f "$file"
        ;;
    "󰖵 Window")
        hyprshot -m window -o "$dir" -f "$file"
        ;;
    *)
        exit 1
        ;;
esac
