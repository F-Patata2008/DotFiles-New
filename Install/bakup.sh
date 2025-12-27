#!/bin/zsh
# ==============================================================================
# "REVERSE STOW" SCRIPT FOR SYSTEM-FILES
#
# This script reads the structure of the 'system-files' directory, finds the
# corresponding files in the root filesystem (/), and copies them back into
# this repository, effectively updating your tracked system configurations.
# ==============================================================================

# --- CONFIGURATION AND SAFETY ---
set -u; set -o pipefail
cd "$(dirname "$0")" # Run from the script's location (Install/)
readonly DOTFILES_DIR=$(git rev-parse --show-toplevel)
readonly SYSTEM_FILES_DIR="$DOTFILES_DIR/Install/system-files"

# --- HELPER FUNCTIONS AND COLORS ---
readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}>>> $1${NC}"; }
log_info() { echo -e "${GREEN}  ✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}  !${NC} $1"; }
log_error() { echo -e "${RED}  ✗${NC} $1"; }

# --- SCRIPT EXECUTION ---
sudo -v # Request sudo privileges upfront

print_header "Backing up system files to Dotfiles repo"
log_info "Source: / (Root Filesystem)"
log_info "Destination: $SYSTEM_FILES_DIR"
echo ""

if [ ! -d "$SYSTEM_FILES_DIR" ]; then
    log_error "Directory '$SYSTEM_FILES_DIR' not found. Aborting."
    exit 1
fi

# Find every FILE inside the system-files directory
# The -print0 and read -d '' part ensures it works with filenames with spaces
find "$SYSTEM_FILES_DIR" -type f -print0 | while IFS= read -r -d '' repo_file; do
    
    # 1. Get the relative path from the 'system-files' root
    # Example: /home/user/Dotfiles/Install/system-files/etc/tlp.conf -> /etc/tlp.conf
    relative_path="${repo_file#$SYSTEM_FILES_DIR}"

    # 2. This relative path is the actual system path
    source_path="$relative_path"

    # 3. Check if the source file actually exists on the system
    if [ -f "$source_path" ]; then
        # 4. Copy the live system file back to the repo, preserving permissions
        # -a: archive mode (preserves permissions, ownership, timestamps)
        # -v: verbose (shows what's being copied)
        sudo cp -afv "$source_path" "$repo_file"
    else
        log_warn "File '$source_path' not found on system. Skipping backup for this file."
    fi
done

print_header "Fixing file ownership"
log_info "Ensuring all files in the Dotfiles repo belong to you..."
# This prevents git permission errors after copying files with sudo
sudo chown -R "$(logname)":"$(id -gn "$(logname)")" "$DOTFILES_DIR"
log_info "✔️ Permissions fixed."

echo ""
print_header "Backup complete!"
log_info "You can now review the changes with 'git diff' in your Dotfiles directory."
