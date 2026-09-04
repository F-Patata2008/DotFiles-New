#!/bin/bash
# ==============================================================================
# ARCH LINUX DISTRIBUTION INSTALLER
# Configures pacman, builds yay, installs pacman & AUR packages
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log_info() { echo -e "${GREEN}[ARCH INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[ARCH WARN]${NC} $1"; }

# 1. Pacman Configuration
log_info "Configuring pacman multilib & system settings..."
if [ -f "$SCRIPT_DIR/system-files/etc/pacman.conf" ]; then
    sudo cp "$SCRIPT_DIR/system-files/etc/pacman.conf" /etc/pacman.conf
    sudo pacman -Sy
elif ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Sy
fi

# 2. Yay AUR Helper
if ! command -v yay &> /dev/null; then
    log_info "Building yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    YAY_TMP=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$YAY_TMP"
    (cd "$YAY_TMP" && makepkg -si --noconfirm)
    rm -rf "$YAY_TMP"
fi

# 3. Pacman & AUR Package Installation
log_info "Installing official repository packages..."
if [ -f "$SCRIPT_DIR/pacman-all.txt" ]; then
    sudo pacman -S --needed --noconfirm - < <(grep -v '^#' "$SCRIPT_DIR/pacman-all.txt" | grep -v '^$') || true
fi

log_info "Installing AUR packages..."
if [ -f "$SCRIPT_DIR/aur-all.txt" ]; then
    yay -S --needed --noconfirm - < <(grep -v '^#' "$SCRIPT_DIR/aur-all.txt" | grep -v '^$') || true
fi

# 4. Cron package backup job
if [ -f "$SCRIPT_DIR/system-files/etc/cron.d/pacman-packages" ]; then
    sudo cp "$SCRIPT_DIR/system-files/etc/cron.d/pacman-packages" /etc/cron.d/pacman-packages
fi

# 5. PAM tweaks for fingerprint
if lsusb | grep -qi "27c6:55b4"; then
    log_info "Configuring PAM for Goodix fingerprint on Arch..."
    if [ -d "$SCRIPT_DIR/system-files/etc/pam.d" ]; then
        sudo cp -r "$SCRIPT_DIR/system-files/etc/pam.d/"* /etc/pam.d/
    fi
    sudo systemctl enable fprintd.service || true
fi

log_info "Arch Linux package installation complete!"
