#!/bin/bash
# ==============================================================================
# ARCH SN750 CUSTOM BOOT INSTALLER
# Deploys LUKS+LVM mkinitcpio hooks, Minegrub GRUB theme, and Minecraft Plymouth
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log_info() { echo -e "${GREEN}[SN750 BOOT]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[SN750 WARN]${NC} $1"; }
log_err() { echo -e "${RED}[SN750 ERROR]${NC} $1"; }

if [ ! -f /etc/arch-release ]; then
    log_err "CRITICAL: This boot setup is exclusively for Arch Linux on the WD Black SN750 SSD!"
    log_err "Aborting to prevent corrupting your current bootloader."
    exit 1
fi

echo -e "\n${YELLOW}==================================================================${NC}"
echo -e "${YELLOW} WARNING: You are about to deploy the Custom SN750 Boot Configuration${NC}"
echo -e "${YELLOW} Features: LUKS Encryption, LVM (Patata-*), Minegrub, Plymouth MC${NC}"
echo -e "${YELLOW}==================================================================${NC}\n"
read -rp "Are you sure you want to apply this to the current Arch system? [y/N]: " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    log_info "Operation cancelled by user."
    exit 0
fi

# 1. Themes: Minegrub & Minecraft Plymouth
log_info "Deploying Minegrub theme..."
sudo mkdir -p /boot/grub/themes
sudo cp -r "$SCRIPT_DIR/system-files/boot/grub/themes/minegrub" /boot/grub/themes/

log_info "Deploying Minecraft Plymouth theme..."
sudo mkdir -p /usr/share/plymouth/themes
sudo cp -r "$SCRIPT_DIR/system-files/usr/share/plymouth/themes/mc" /usr/share/plymouth/themes/
if command -v plymouth-set-default-theme &>/dev/null; then
    sudo plymouth-set-default-theme mc
fi

# 2. mkinitcpio (with encrypt, lvm2, plymouth, resume)
log_info "Updating /etc/mkinitcpio.conf..."
sudo cp "$SCRIPT_DIR/system-files/etc/mkinitcpio.conf" /etc/mkinitcpio.conf
log_info "Regenerating initramfs..."
sudo mkinitcpio -P

# 3. GRUB Configuration
log_info "Deploying GRUB default configuration..."
sudo cp "$SCRIPT_DIR/system-files/etc/default/grub" /etc/default/grub
log_info "Updating GRUB boot menu..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

log_info "Custom SN750 Boot setup completed successfully!"
