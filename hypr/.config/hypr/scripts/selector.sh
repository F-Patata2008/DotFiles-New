#!/bin/bash

BASE_PROJECTS_DIR="$HOME/Progra"

# Check if the base directory exists
if [ ! -d "$BASE_PROJECTS_DIR" ]; then
    echo "Base project directory '$BASE_PROJECTS_DIR' not found." >&2
    exit 1
fi

# Find all directories within BASE_PROJECTS_DIR, excluding .git folders.
# Then sort them by name in descending order.
# Use sed to remove the BASE_PROJECTS_DIR prefix for a cleaner display in Rofi.
SELECTED_PATH=$(find "$BASE_PROJECTS_DIR" -mindepth 1 \( -name ".git" -prune \) -o -type d -print0 | \
                sort -rz | \
                sed -z "s|^${BASE_PROJECTS_DIR}/||" | \
                rofi -dmenu -p "Select Project Directory:" -sep '\0' -location 0 -display-drun "")

# Check if a path was selected
if [ -n "$SELECTED_PATH" ]; then
    # Execute your env.sh script with the selected project path.
    # Since SELECTED_PATH is now relative, we need to prepend BASE_PROJECTS_DIR again.
    ~/.config/hypr/scripts/env.sh "$BASE_PROJECTS_DIR/$SELECTED_PATH"
else
    echo "No project directory selected."
fi
