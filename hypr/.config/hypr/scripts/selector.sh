#!/bin/bash

BASE_PROJECTS_DIR="$HOME/Progra"

# Check if the base directory exists
if [ ! -d "$BASE_PROJECTS_DIR" ]; then
    echo "Base project directory '$BASE_PROJECTS_DIR' not found." >&2
    exit 1
fi

TEMP_ROFI_INPUT=$(mktemp)

find "$BASE_PROJECTS_DIR" -mindepth 1 -type d -print0 | \
    grep -vzP "^$(printf '%q' "$BASE_PROJECTS_DIR")\/.git($|\/)" | \
    sort -rz | \
    sed -z "s|^$(printf '%q' "$BASE_PROJECTS_DIR")/||" | \
    tr '\0' '\n' | \
    rofi -dmenu -p "Select Project Directory:" -location 0 -display-drun "" > "$TEMP_ROFI_INPUT"

read -r SELECTED_RELATIVE_PATH < "$TEMP_ROFI_INPUT"

rm "$TEMP_ROFI_INPUT"

if [ -n "$SELECTED_RELATIVE_PATH" ]; then
    # Construct the full path with explicit quoting for the shell.
    # This is more robust if SELECTED_RELATIVE_PATH has tricky characters.
    FULL_PROJECT_PATH="$(printf '%q' "$BASE_PROJECTS_DIR")/$SELECTED_RELATIVE_PATH"
    
    # Execute env.sh, ensuring the path is passed as a single, quoted argument.
    # We can even try executing env.sh with bash -c to be very explicit about quoting.
    bash -c "~/.config/hypr/scripts/env.sh $(printf '%q' \"$BASE_PROJECTS_DIR/$SELECTED_RELATIVE_PATH\")"
else
    echo "No project directory selected."
fi
