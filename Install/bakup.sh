#!/bin/bash
# ==============================================================================
# PROFILE-SAFE SYSTEM-FILES REVERSE BACKUP (V6.0)
# Syncs live root configurations into the dotfiles repo safely
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
log_info() { echo -e "${GREEN}  ✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}  !${NC} $1"; }
log_err() { echo -e "${RED}  ✗${NC} $1"; }

sudo -v

echo -e "\n${BLUE}========================================\n PROFILE-SAFE SYSTEM BACKUP \n========================================${NC}\n"

# Helper to reverse-sync files from a directory
sync_system_files() {
    local target_dir="$1"
    local desc="$2"

    [ ! -d "$target_dir" ] && return 0
    echo -e "${YELLOW}>>> Syncing $desc: $target_dir${NC}"

    find "$target_dir" -type f -print0 | while IFS= read -r -d '' repo_file; do
        # Extract relative path after system-files/
        local clean_path
        clean_path="${repo_file#$target_dir/}"
        local source_path="/$clean_path"

        # Ignore backup reference files
        if [[ "$repo_file" =~ \.reference$ ]]; then
            continue
        fi

        if [ -f "$source_path" ]; then
            sudo cp -af "$source_path" "$repo_file"
            log_info "$source_path -> ${repo_file#$DOTFILES_DIR/}"
        else
            log_warn "$source_path not present on live filesystem (skipped)"
        fi
    done
}

# 1. Always safe: Universal system files
sync_system_files "$SCRIPT_DIR/system-files/common" "Universal Configurations"

# 2. Distro-specific system files
if [ -f /etc/fedora-release ]; then
    log_info "Active OS: Fedora Linux. Syncing Fedora profiles..."
    sync_system_files "$SCRIPT_DIR/profiles/distros/fedora/system-files" "Fedora System Files"
elif [ -f /etc/arch-release ]; then
    log_info "Active OS: Arch Linux. Syncing Arch profiles..."
    sync_system_files "$SCRIPT_DIR/profiles/distros/arch/system-files" "Arch System Files"
fi

# 3. Machine Hardware profile
if lsusb | grep -qi "27c6:55b4" || ( [ -f /sys/class/dmi/id/product_name ] && grep -qi "E41-55" /sys/class/dmi/id/product_name ); then
    sync_system_files "$SCRIPT_DIR/profiles/machines/lenovo-e41-55/system-files" "Lenovo E41-55 Hardware Files"
fi

# 4. Arch SN750 Custom Boot (Only on Arch when explicitly confirmed)
if [ -f /etc/arch-release ] && [ -d "$SCRIPT_DIR/profiles/machines/arch-sn750-custom-boot/system-files" ]; then
    echo -e "\n${YELLOW}Sync WD Black SN750 Custom Bootloader files (GRUB, mkinitcpio)?${NC}"
    read -rp "Sync SN750 boot configs? [y/N]: " SYNC_BOOT
    if [[ "$SYNC_BOOT" =~ ^[Yy]$ ]]; then
        sync_system_files "$SCRIPT_DIR/profiles/machines/arch-sn750-custom-boot/system-files" "SN750 Boot Configuration"
    fi
fi

# Fix ownership back to standard user
MY_USER=$(logname 2>/dev/null || echo "${SUDO_USER:-$USER}")
if [ -n "$MY_USER" ]; then
    sudo chown -R "$MY_USER":"$(id -gn "$MY_USER")" "$SCRIPT_DIR"
fi

echo -e "\n${GREEN}Backup completed safely without cross-distro corruption!${NC}\n"
