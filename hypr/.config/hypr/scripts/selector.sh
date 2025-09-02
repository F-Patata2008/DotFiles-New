#!/bin/bash

# The base directory where your projects are organized
# In your case, it seems to be ~/Progra, and within that, you have subfolders
BASE_PROJECTS_DIR="$HOME/Progra"

# Check if the base directory exists
if [ ! -d "$BASE_PROJECTS_DIR" ]; then
    echo "Base project directory '$BASE_PROJECTS_DIR' not found." >&2
    exit 1
fi

# Use Rofi to select a directory from the base directory.
# We'll present a list of all directories within BASE_PROJECTS_DIR.
# The user can then navigate or type to find their desired subfolder.
# -select option is not standard dmenu, so we'll rely on the user typing or navigating.
# The output of rofi will be the full path.

# IMPORTANT: The -theme part is removed as requested.
SELECTED_PATH=$(find "$BASE_PROJECTS_DIR" -type d -print0 | \
                rofi -dmenu -p "Select Project Directory:" -sep '\0' -location 0 -display-drun "")

# Check if a path was selected
if [ -n "$SELECTED_PATH" ]; then
    # Execute your env.sh script with the selected project path
    # Assuming env.sh is in ~/.config/hypr/scripts/
    ~/.config/hypr/scripts/env.sh "$SELECTED_PATH"
else
    echo "No project directory selected."
fi
