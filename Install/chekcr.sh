#!/bin/bash

# Define the directory to check and the output file
DOTFILES_DIR="$HOME/Dotfiles"
# --- CHANGE IS HERE ---
# Create the output file in the home directory to avoid conflicts
OUTPUT_FILE="$HOME/dotfiles_content.txt"

# Check if the Dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Directory $DOTFILES_DIR does not exist."
  exit 1
fi

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Loop through every file in the Dotfiles directory
for file in "$DOTFILES_DIR"/*
do
  # Check if the current item is a regular file
  if [ -f "$file" ]; then
    # Get just the filename from the full path
    filename=$(basename "$file")

    # Append the filename to the output file
    echo "=========================================" >> "$OUTPUT_FILE"
    echo "File: $filename" >> "$OUTPUT_FILE"
    echo "=========================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Append the content of the file to the output file
    cat "$file" >> "$OUTPUT_FILE"

    # Add a newline for spacing between file contents
    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  fi
done

echo "Process complete. The contents of all files have been saved to $OUTPUT_FILE"
