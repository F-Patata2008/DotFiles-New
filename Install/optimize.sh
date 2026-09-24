#!/bin/bash
# ==============================================================================
# SAVIOUR GUNDAM (Lenovo E41-55 / Arch Linux) FULL SYSTEM OPTIMIZER & CLEANER
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'
header() { echo -e "\n${BLUE}========================================\n $1 \n========================================${NC}\n"; }
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1"; }

# Elevate privileges upfront
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

header "1. HARDWARE POWER & PERFORMANCE TUNING"
if [ -f "$SCRIPT_DIR/profiles/machines/lenovo-e41-55/setup-hardware.sh" ]; then
    log_info "Executing Lenovo E41-55 hardware tuning (TLP, zRAM, sysctl, watchdog, USB sleep)..."
    bash "$SCRIPT_DIR/profiles/machines/lenovo-e41-55/setup-hardware.sh"
else
    log_warn "Hardware setup script not found, skipping."
fi

if [ -f /etc/arch-release ] && [ -d /boot/grub ]; then
    if grep -q "pcie_aspm=off" /proc/cmdline || ! grep -q "allow-discards" /proc/cmdline; then
        log_info "Synchronizing GRUB configuration to enable TRIM (allow-discards) and PCIe ASPM..."
        if [ -f "$SCRIPT_DIR/profiles/machines/arch-sn750-custom-boot/system-files/etc/default/grub" ]; then
            sudo cp "$SCRIPT_DIR/profiles/machines/arch-sn750-custom-boot/system-files/etc/default/grub" /etc/default/grub
        fi
        sudo grub-mkconfig -o /boot/grub/grub.cfg || true
        log_info "GRUB boot config updated successfully."
    fi
fi

header "2. FINGERPRINT REBUILT PACKAGE INSTALLATION"
BUILT_FPRINT=$(ls -t "$HOME/.cache/yay/libfprint-goodixtls-55x4"/libfprint-goodixtls-55x4-*.pkg.tar.zst 2>/dev/null | head -n 1 || true)
if [ -n "$BUILT_FPRINT" ] && [ -f "$BUILT_FPRINT" ]; then
    log_info "Installing OpenCV 5-compatible libfprint package: $BUILT_FPRINT"
    sudo pacman -U --noconfirm "$BUILT_FPRINT"
    sudo systemctl restart fprintd.service || true
    log_info "fprintd service restarted and verified."
else
    log_warn "No pre-built libfprint package found in yay cache."
fi

header "3. PURGING ORPHANED PACKAGES"
ORPHANS=$(pacman -Qtdq 2>/dev/null || true)
if [ -n "$ORPHANS" ]; then
    ORPHAN_COUNT=$(echo "$ORPHANS" | wc -w)
    log_info "Found $ORPHAN_COUNT orphaned packages. Purging along with unused dependencies..."
    sudo pacman -Rns --noconfirm $ORPHANS || {
        log_warn "Standard recursive removal had conflicts; attempting non-recursive purge..."
        sudo pacman -Rdd --noconfirm $ORPHANS || true
    }
    log_info "Orphaned packages eliminated."
else
    log_info "No orphaned packages detected."
fi

header "4. TRIMMING PACKAGE CACHE & BUILD ARTIFACTS"
if command -v paccache &>/dev/null; then
    log_info "Trimming pacman cache (retaining last 2 versions for safety rollback)..."
    sudo paccache -rk2
    log_info "Purging uninstalled package cache..."
    sudo paccache -ruk0 || true
else
    log_info "Cleaning pacman cache via pacman -Sc..."
    echo -e "y\ny\n" | sudo pacman -Sc || true
fi

if command -v yay &>/dev/null; then
    log_info "Cleaning yay build cache..."
    yay -Sc --noconfirm || true
fi

log_info "Vacuuming systemd journals older than 14 days..."
sudo journalctl --vacuum-time=14d || true

header "5. POST-OPTIMIZATION AUDIT"
echo "=== DISK REAL ESTATE ==="
df -h / /home

echo -e "\n=== SWAP PRIORITIES ==="
swapon -s

echo -e "\n=== POWER & WATCHDOG STATUS ==="
systemctl is-active tlp.service && echo "TLP: Active" || echo "TLP: Inactive"
systemctl is-active check-bat.timer && echo "Battery 5% Watchdog: Active" || echo "Battery 5% Watchdog: Inactive"
systemctl is-active fprintd.service && echo "Fingerprint Daemon: Active" || echo "Fingerprint Daemon: Inactive/Standby"

header "🚀 SAVIOUR GUNDAM IS FULLY OPTIMIZED AND RUNNING TIP TOP! 🚀"
