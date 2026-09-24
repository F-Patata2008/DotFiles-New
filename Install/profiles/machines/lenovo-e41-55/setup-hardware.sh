#!/bin/bash
# ==============================================================================
# HARDWARE PROFILE: Lenovo E41-55 (Ryzen 3 3250U / Goodix Biometrics)
# Distro-intelligent hardware tuning
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log_info() { echo -e "${GREEN}[LENOVO HW]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[LENOVO HW]${NC} $1"; }

# 1. Hardware Udev Rules (Fingerprint power-save & Arduino/serial permissions)
log_info "Installing hardware udev rules..."
if [ -d "$SCRIPT_DIR/system-files/etc/udev/rules.d" ]; then
    sudo cp -r "$SCRIPT_DIR/system-files/etc/udev/rules.d/"* /etc/udev/rules.d/
    sudo udevadm control --reload-rules && sudo udevadm trigger || true
fi

# 2. Goodix Fingerprint Hang Watchdog (fprintd drop-in)
if [ -d "$SCRIPT_DIR/system-files/etc/systemd/system/fprintd.service.d" ]; then
    log_info "Installing fprintd watchdog timeout drop-in..."
    sudo mkdir -p /etc/systemd/system/fprintd.service.d/
    sudo cp -r "$SCRIPT_DIR/system-files/etc/systemd/system/fprintd.service.d/"* /etc/systemd/system/fprintd.service.d/
    sudo systemctl daemon-reload
    sudo systemctl restart fprintd.service || true
fi

# 2. Battery Watchdog (check-bat at <= 5% -> Hibernate)
log_info "Installing check-bat low battery hibernation watchdog..."
if [ -f "$SCRIPT_DIR/system-files/usr/local/bin/check-bat" ]; then
    sudo cp "$SCRIPT_DIR/system-files/usr/local/bin/check-bat" /usr/local/bin/
    sudo chmod +x /usr/local/bin/check-bat
fi
if [ -f "$SCRIPT_DIR/system-files/etc/systemd/system/check-bat.service" ]; then
    sudo cp "$SCRIPT_DIR/system-files/etc/systemd/system/check-bat.service" /etc/systemd/system/
    sudo cp "$SCRIPT_DIR/system-files/etc/systemd/system/check-bat.timer" /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable --now check-bat.timer || true
fi

# 3. Power Management Tuning (Distro-Aware)
# Fedora has excellent out-of-the-box power-profiles-daemon/tuned integration.
# Arch Linux requires TLP for aggressive Vega 3 & CPU power saving.
if [ -f /etc/arch-release ]; then
    log_info "Arch Linux detected: Deploying aggressive TLP power management for Ryzen 3 3250U..."
    sudo cp "$SCRIPT_DIR/system-files/etc/tlp.conf" /etc/tlp.conf
    # Ensure conflicting power daemons are masked on Arch
    sudo systemctl mask power-profiles-daemon.service 2>/dev/null || true
    sudo systemctl enable --now tlp.service || true
elif [ -f /etc/fedora-release ]; then
    log_info "Fedora Linux detected: Preserving Fedora native power-profiles-daemon integration."
    log_info "(TLP profile is preserved in $SCRIPT_DIR/system-files/etc/tlp.conf if ever needed)."
else
    log_warn "Generic distro detected. Would you like to enable TLP? (y/n)"
    read -rp "Enable TLP? [y/N]: " ENABLE_TLP
    if [[ "$ENABLE_TLP" =~ ^[Yy]$ ]]; then
        sudo cp "$SCRIPT_DIR/system-files/etc/tlp.conf" /etc/tlp.conf
    fi
fi

# 4. zRAM & Kernel Memory Tuning (Zen+ 2400MHz APU Optimization)
log_info "Deploying zRAM and kernel performance parameters..."
if [ -f "$SCRIPT_DIR/system-files/etc/systemd/zram-generator.conf" ]; then
    sudo mkdir -p /etc/systemd/
    sudo cp "$SCRIPT_DIR/system-files/etc/systemd/zram-generator.conf" /etc/systemd/zram-generator.conf
    # Restart zram service to reconfigure with zstd & full RAM allocation
    if command -v systemctl &>/dev/null; then
        sudo swapoff /dev/zram0 2>/dev/null || true
        if [ -f /sys/block/zram0/reset ]; then
            echo 1 | sudo tee /sys/block/zram0/reset >/dev/null 2>&1 || true
        fi
        sudo systemctl daemon-reload
        sudo systemctl restart systemd-zram-setup@zram0.service || true
    fi
fi
if [ -f "$SCRIPT_DIR/system-files/etc/sysctl.d/99-lenovo-performance.conf" ]; then
    sudo mkdir -p /etc/sysctl.d/
    sudo cp "$SCRIPT_DIR/system-files/etc/sysctl.d/99-lenovo-performance.conf" /etc/sysctl.d/
    sudo sysctl --system >/dev/null 2>&1 || true
fi

# 5. SSD TRIM Optimization
if command -v systemctl &>/dev/null; then
    log_info "Enabling weekly SSD TRIM timer (fstrim.timer)..."
    sudo systemctl enable --now fstrim.timer || true
fi

# 6. Backpack Oven Prevention (Disable USB ACPI Wakeup)
if [ -f "$SCRIPT_DIR/system-files/etc/systemd/system/disable-usb-wakeup.service" ]; then
    log_info "Installing disable-usb-wakeup service (prevents mouse clicks in backpack waking laptop)..."
    sudo cp "$SCRIPT_DIR/system-files/etc/systemd/system/disable-usb-wakeup.service" /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable --now disable-usb-wakeup.service || true
fi

# 7. Browser Hardware Acceleration (Vega 3 VCN 1.0 Optimization)
# Disables CPU-burning AV1 decode and forces VA-API hardware VP9/H.264 decoding
if [ -d "$HOME/.config/zen" ]; then
    for ZEN_PROFILE in "$HOME"/.config/zen/*/; do
        if [ -d "$ZEN_PROFILE" ] && [[ "$ZEN_PROFILE" =~ \.(default|Default) ]]; then
            cat << 'EOF' > "${ZEN_PROFILE}user.js"
// Generated by Patata Dotfiles (Lenovo E41-55 Vega 3 tuning)
user_pref("media.av1.enabled", false);
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("gfx.webrender.all", true);
EOF
            log_info "Configured Vega 3 hardware acceleration for Zen profile: $(basename "$ZEN_PROFILE")"
        fi
    done
fi

log_info "Lenovo E41-55 hardware profile successfully applied!"
