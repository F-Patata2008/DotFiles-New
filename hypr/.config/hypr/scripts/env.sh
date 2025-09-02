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
kitty --title code --class code_window --cwd "$PROJECT_PATH" nvim . &
sleep 0.2 # Give Kitty a moment to initialize for the rule to catch it

# Input Window (nvim input): 1/4 of the remaining vertical space on the right
kitty --title input --class input_window --cwd "$PROJECT_PATH" nvim input &
sleep 0.2

# Compile Window (cd ...): next 1/4 vertical space
# Using zsh -c to execute commands in a new zsh instance
kitty --title compile --class compile_window --cwd "$PROJECT_PATH" zsh -c "cd \"$PROJECT_PATH\"; zsh" &
sleep 0.2

# Exec Window (cd ...): remaining 1/2 vertical space
# Using zsh -c to execute commands in a new zsh instance
kitty --title exec --class exec_window --cwd "$PROJECT_PATH" zsh -c "cd \"$PROJECT_PATH\"; zsh" &
sleep 0.2
