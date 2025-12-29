#!/bin/bash
#
# This script atomically updates the package lists for the dotfiles repository.

# Ensure the script runs from its own directory
cd "$(dirname "$0")"

echo "Updating Pacman package list..."
# 1. Generate the new list in a temporary file
if pacman -Qenq > pacman_packages.txt.tmp; then
    # 2. If the command was successful, replace the old file with the new one
    mv pacman_packages.txt.tmp pacman_packages.txt
    log_info "Pacman list updated."
else
    # 3. If it failed, clean up the temp file and report error
    rm -f pacman_packages.txt.tmp
    log_error "Failed to generate Pacman package list."
fi

echo "Updating AUR package list..."
if pacman -Qemq > aur_packages.txt.tmp; then
    mv aur_packages.txt.tmp aur_packages.txt
    log_info "AUR list updated."
else
    rm -f aur_packages.txt.tmp
    log_error "Failed to generate AUR package list."
fi

echo "✅ Package lists updated successfully."
