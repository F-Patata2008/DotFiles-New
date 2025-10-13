#!/bin/zsh

# --- Configuration ---
# The directory you want to scan. The ~ will automatically expand to your home directory.
# This path matches the structure you described.
SOURCE_DIR=~/Dotfiles/nvim/.config/nvim

# The name of the output file. This will be created in your home directory.
OUTPUT_FILE=~/nvim.txt
# --- End of Configuration ---

# Check if the source directory actually exists before we start.
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory not found at '$SOURCE_DIR'"
  exit 1
fi

# Create or clear the output file to ensure we start fresh every time.
> "$OUTPUT_FILE"

echo "Starting to export Neovim configuration to $OUTPUT_FILE..."

# Use the 'find' command to locate all files (-type f) within the source directory.
# Then, loop through each file path that 'find' discovers.
find "$SOURCE_DIR" -type f | while read -r file; do
    
    # Get the file path relative to the source directory for a cleaner title.
    # This removes the "~/Dotfiles/nvim/.config/nvim/" part from the front.
    relative_path=${file#"$SOURCE_DIR/"}

    # 1. Write the file name followed by a colon to nvim.txt
    echo "--- File: ${relative_path} ---" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE" # Add a little space after the title

    # 2. Append the entire content of the current file
    cat "$file" >> "$OUTPUT_FILE"
    
    # 3. Append four lines of jump (blank lines) for separation
    printf '\n\n\n\n' >> "$OUTPUT_FILE"
    
done

echo "Export complete! Your configuration has been saved to $OUTPUT_FILE"
