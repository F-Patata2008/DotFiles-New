#!/bin/bash
#
# This script automatically updates the package lists for the dotfiles repository.

# Ensure the script runs from its own directory to find the package files
cd "$(dirname "$0")"
rm aur_packages.txt
rm pacman_packages.txt

echo "Updating Pacman package list..."
pacman -Qenq > pacman_packages.txt

echo "Updating AUR package list..."
pacman -Qemq > aur_packages.txt

echo "✅ Package lists updated successfully."
