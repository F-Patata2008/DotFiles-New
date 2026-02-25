#!/bin/bash
# ==============================================================================
# "REVERSE STOW" SCRIPT FOR SYSTEM-FILES (V5.0 MODULAR)
# Updates tracked system configurations from the live root filesystem.
# ==============================================================================

set -u; set -o pipefail
cd "$(dirname "$0")" # Run from the Install/ directory
readonly DOTFILES_DIR=$(git rev-parse --show-toplevel)
readonly SYSTEM_FILES_DIR="$DOTFILES_DIR/Install/system-files"

# --- HELPER FUNCTIONS ---
readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}>>> $1${NC}"; }
log_info() { echo -e "${GREEN}  ✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}  !${NC} $1"; }
log_error() { echo -e "${RED}  ✗${NC} $1"; }

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
find "$SYSTEM_FILES_DIR" -type f -print0 | while IFS= read -r -d '' repo_file; do

    # 1. Get relative path (e.g., "common/etc/tlp.conf" or "machines/lenovo/etc/fstab")
    relative_path="${repo_file#$SYSTEM_FILES_DIR/}"

    # 2. Strip the 'common/' or 'machines/<name>/' prefix dynamically
    clean_path=$(echo "$relative_path" | sed -E 's/^(common|machines\/[^/]+)\///')

    # 3. Add root slash to get the real system path (e.g., "/etc/tlp.conf")
    source_path="/$clean_path"

    # 4. Check and Copy
    if [ -f "$source_path" ]; then
        sudo cp -af "$source_path" "$repo_file"
    else
        log_warn "File '$source_path' not found on system. Skipping."
    fi
done

print_header "Fixing file ownership"
log_info "Ensuring all files in the repo belong to your user..."

# Safely get the real user, even if running via sudo
MY_USER=$(logname 2>/dev/null || echo $SUDO_USER)
if [ -n "$MY_USER" ]; then
    sudo chown -R "$MY_USER":"$(id -gn "$MY_USER")" "$DOTFILES_DIR/Install/system-files"
    log_info "✔️ Permissions fixed."
else
    log_warn "Could not determine user. Run 'sudo chown -R \$USER:\$USER .' manually."
fi

echo ""
print_header "Backup complete!"
log_info "You can now review the changes with 'git diff'."
