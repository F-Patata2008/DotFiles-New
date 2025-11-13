#!/bin/bash

# Define the directory to check and the output file
DOTFILES_DIR="$HOME/Dotfiles"
OUTPUT_FILE="$HOME/Dotfiles/dotfiles_content.txt"

# Check if the Dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Directory $DOTFILES_DIR does not exist."
  exit 1
fi

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Find all files, applying all exclusion rules, and process them
find "$DOTFILES_DIR" -type f \
  -not -path "*/.git/*" \
  -not -path "*/ohmyzsh/*" \
  -not -name "push.log" \
  -not -path "$DOTFILES_DIR/Wallpapers/*" \
  -not -path "$DOTFILES_DIR/Install/system-files/boot/*" \
  -not -path "$DOTFILES_DIR/Install/system-files/usr/share/*" | while IFS= read -r file; do
    # Get the relative path from the Dotfiles directory
    relative_path=${file#$DOTFILES_DIR/}

    # Append the filename and path to the output file
    echo "=========================================" >> "$OUTPUT_FILE"
    echo "File: $relative_path" >> "$OUTPUT_FILE"
    echo "=========================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Append the content of the file to the output file
    cat "$file" >> "$OUTPUT_FILE"

    # Add a newline for spacing between file contents
    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "Process complete. The contents of all files have been saved to $OUTPUT_FILE"
