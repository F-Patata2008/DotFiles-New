#!/bin/bash

PROJECTS_DIR="$HOME/Progra" # CHANGE THIS TO YOUR PROJECTS DIRECTORY

# Check if the directory exists
if [ ! -d "$PROJECTS_DIR" ]; then
    echo "Project directory '$PROJECTS_DIR' not found." >&2
    exit 1
fi

# Use Rofi to select a project directory
SELECTED_PROJECT=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | \
                   rofi -dmenu -p "Select Project:" -sep '\0' -location 0 -display-drun "")

# Check if a project was selected
if [ -n "$SELECTED_PROJECT" ]; then
    # Execute your env.sh script with the selected project path
    ~/.config/hypr/scripts/env.sh "$SELECTED_PROJECT"
else
    echo "No project selected."
fi
