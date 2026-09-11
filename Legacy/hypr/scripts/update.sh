#!/bin/zsh

# Go to the script's directory to ensure log files are created locally
cd "$(dirname "$0")"

# --- Configuration ---
LOG_FILE="$PWD/update.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
GITIGNORE_FILE="$PWD/.gitignore"

# --- Function for sending notifications ---
# D-Bus is needed for notify-send to work correctly from a script run with sudo
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

notify() {
  notify-send "Pacman Updater" "$1" -i "system-software-update"
}

# --- Automatically ignore the log file in git ---
# Check if the log file is already in .gitignore and add it if not
if ! grep -q "^$(basename "$LOG_FILE")$" "$GITIGNORE_FILE" 2>/dev/null; then
  echo "\n# Ignore update script log" >> "$GITIGNORE_FILE"
  echo "$(basename "$LOG_FILE")" >> "$GITIGNORE_FILE"
fi

# --- Main Script Logic ---
# Redirect all output (stdout and stderr) to both the console and the log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========== Starting Update: $TIMESTAMP =========="

# 1. Update Mirrorlist with Reflector
echo "Updating mirrorlist for best performance..."
if sudo reflector --country 'Chile,Argentina,Brazil,Peru' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist; then
  echo "[OK] Mirrorlist updated successfully."
else
  echo "[ERROR] Failed to update mirrorlist with reflector."
  notify "❌ Error: Failed to update mirrorlist."
  exit 1 # Exit the script with an error code
fi

# 2. Perform Full System Upgrade (Official Repos + AUR)
echo "Starting full system upgrade (Official Repos + AUR)..."
# We remove --noconfirm for safety. It's better to manually confirm packages.
if yay -Syuu --sudoloop; then
  echo "[SUCCESS] System upgrade completed successfully at $(date '+%Y-%m-%d %H:%M:%S')."
  notify "✅ System is up-to-date!"
else
  echo "[ERROR] The update process failed."
  notify "❌ Error: The update process failed. Check the log."
  exit 1 # Exit the script with an error code
fi

echo "=================================================="
echo ""
