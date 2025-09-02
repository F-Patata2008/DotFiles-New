#!/bin/bash

# Check if a path argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path/to/your/project>"
  exit 1
fi

PROJECT_PATH="$1"

# --- Tiling Layout Script ---

# 1. Launch the main code window first. It will occupy the entire workspace.
#    We use --class to identify it in hyprland.conf.
kitty --class code_window --working-directory "$PROJECT_PATH" nvim . &
sleep 0.5 # Wait for the window to open and be focused

# 2. Set the split ratio for the NEXT window.
#    A value of 0.34 means the new window will take 34% of the space,
#    leaving the current 'code_window' with 66%.
hyprctl dispatch splitratio 0.34

# 3. Launch the first of the smaller windows. This will create the split.
kitty --class input_window --working-directory "$PROJECT_PATH" nvim input &
sleep 0.3 # Wait a moment

# 4. Launch the remaining windows. The dwindle layout will automatically
#    stack them vertically in the smaller pane.
kitty --class compile_window --working-directory "$PROJECT_PATH" zsh -c "cd \"$PROJECT_PATH\"; zsh" &
sleep 0.3 # Wait a moment

kitty --class exec_window --working-directory "$PROJECT_PATH" zsh -c "cd \"$PROJECT_PATH\"; zsh" &
