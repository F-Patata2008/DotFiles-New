#!/bin/bash

# Check if a path argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path/to/your/project>"
  exit 1
fi

PROJECT_PATH="$1"

# Launch Kitty windows with specific titles and classes
# Workspace 5 is specified in Hyprland rules

# Main Code Window (nvim .): ~2/3 width, left side
kitty --title code --class code_window --working-directory "$PROJECT_PATH" nvim . &

# Input Window (nvim input): 1/4 of the remaining vertical space on the right
kitty --title input --class input_window --working-directory "$PROJECT_PATH" nvim input &

# Compile Window (cd ...): next 1/4 vertical space
kitty --title compile --class compile_window --working-directory "$PROJECT_PATH" zsh -c "cd \"$PROJECT_PATH\"; zsh" &

# Exec Window (cd ...): remaining 1/2 vertical space
kitty --title exec --class exec_window --working-directory "$PROJECT_PATH" zsh -c "cd \"$PROJECT_PATH\"; zsh" &
