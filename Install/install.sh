#!/bin/bash
# ==============================================================================
# UNIFIED MODULAR DOTFILES INSTALLER V6.0
# Multi-Distro (Fedora / Arch) & Hardware-Aware
# ==============================================================================

set -e; set -u; set -o pipefail
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$INSTALL_DIR/.." && pwd)"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
print_header() { echo -e "\n${BLUE}========================================\n $1 \n========================================${NC}\n"; }
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err() { echo -e "${RED}[ERROR]${NC} $1"; }

# Request sudo upfront and maintain session
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "PHASE 1: ENVIRONMENT & HARDWARE DETECTION"

# 1. Distro Detection
DETECTED_DISTRO="generic"
if [ -f /etc/fedora-release ]; then
    DETECTED_DISTRO="fedora"
elif [ -f /etc/arch-release ]; then
    DETECTED_DISTRO="arch"
fi

echo -e "Detected Operating System: ${YELLOW}$DETECTED_DISTRO${NC}"
echo "Select Distro Profile to deploy:"
echo "1) Fedora Linux (DNF5/DNF + Copr + Flatpaks)"
echo "2) Arch Linux (Pacman + Yay AUR)"
echo "3) Skip Distro Packages (Stow and user config only)"

DEFAULT_DISTRO_CHOICE=1
[[ "$DETECTED_DISTRO" == "arch" ]] && DEFAULT_DISTRO_CHOICE=2

read -rp "Selection [1-3, default: $DEFAULT_DISTRO_CHOICE]: " DISTRO_CHOICE
DISTRO_CHOICE=${DISTRO_CHOICE:-$DEFAULT_DISTRO_CHOICE}

# 2. Machine Profile Detection
DETECTED_MACHINE="generic"
if lsusb | grep -qi "27c6:55b4" || ( [ -f /sys/class/dmi/id/product_name ] && grep -qi "E41-55" /sys/class/dmi/id/product_name ); then
    DETECTED_MACHINE="lenovo-e41-55"
fi

echo -e "\nDetected Machine Hardware: ${YELLOW}$DETECTED_MACHINE${NC}"
echo "Select Machine Profile:"
echo "1) Lenovo E41-55 (Goodix Biometrics, Battery Watchdog, Power Profiles)"
echo "2) Generic PC / ThinkPad / VM (Stock settings)"

DEFAULT_MACH_CHOICE=1
[[ "$DETECTED_MACHINE" == "generic" ]] && DEFAULT_MACH_CHOICE=2

read -rp "Selection [1-2, default: $DEFAULT_MACH_CHOICE]: " MACH_CHOICE
MACH_CHOICE=${MACH_CHOICE:-$DEFAULT_MACH_CHOICE}

MACH_PROFILE="generic"
if [ "$MACH_CHOICE" == "1" ]; then
    MACH_PROFILE="lenovo-e41-55"
fi

# 3. Arch SN750 Custom Boot Prompt (Only applicable when Arch is selected)
SN750_BOOT=false
if [ "$DISTRO_CHOICE" == "2" ] && [ "$MACH_PROFILE" == "lenovo-e41-55" ]; then
    echo -e "\n${YELLOW}[SPECIAL DRIVE DETECTED]${NC}"
    echo "Is this target drive the 500GB WD Black SN750 (with LUKS + LVM + Minegrub)?"
    read -rp "Deploy custom SN750 boot configuration? [y/N]: " SN750_RESP
    if [[ "$SN750_RESP" =~ ^[Yy]$ ]]; then
        SN750_BOOT=true
    fi
fi

# ------------------------------------------------------------------------------
# PHASE 2: PACKAGE INSTALLATION
# ------------------------------------------------------------------------------
print_header "PHASE 2: PACKAGE REPOSITORIES & SOFTWARE"

case "$DISTRO_CHOICE" in
    1)
        log_info "Deploying Fedora software profile..."
        bash "$INSTALL_DIR/profiles/distros/fedora/install-fedora.sh"
        ;;
    2)
        log_info "Deploying Arch Linux software profile..."
        bash "$INSTALL_DIR/profiles/distros/arch/install-arch.sh"
        ;;
    3)
        log_info "Skipping package manager installation."
        ;;
esac

# ------------------------------------------------------------------------------
# PHASE 3: ZSH & THEME PREREQUISITES
# ------------------------------------------------------------------------------
print_header "PHASE 3: SHELL & POWERLEVEL10K"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    log_info "Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    log_info "Setting default shell to zsh..."
    chsh -s "$(which zsh)" || log_warn "Could not change shell automatically. Run chsh manually."
fi

# ------------------------------------------------------------------------------
# PHASE 4: COMMON SYSTEM FILES
# ------------------------------------------------------------------------------
print_header "PHASE 4: UNIVERSAL SYSTEM CONFIGURATIONS"
log_info "Deploying universal system files (SDDM, vconsole, sleep/logind)..."
if [ -d "$INSTALL_DIR/system-files/common" ]; then
    sudo cp -rT "$INSTALL_DIR/system-files/common/" /
fi

# ------------------------------------------------------------------------------
# PHASE 5: HARDWARE & BOOT PROFILES
# ------------------------------------------------------------------------------
print_header "PHASE 5: MACHINE & HARDWARE TUNING"
log_info "Applying hardware profile for: $MACH_PROFILE"
bash "$INSTALL_DIR/profiles/machines/$MACH_PROFILE/setup-hardware.sh"

if [ "$SN750_BOOT" = true ]; then
    print_header "PHASE 5B: ARCH SN750 CUSTOM BOOTLOADER"
    bash "$INSTALL_DIR/profiles/machines/arch-sn750-custom-boot/setup-boot.sh"
fi

# ------------------------------------------------------------------------------
# PHASE 6: GNU STOW (USER ENVIRONMENT)
# ------------------------------------------------------------------------------
print_header "PHASE 6: GNU STOW (RICE DEPLOYMENT)"

# Ensure submodules are checked out
log_info "Updating git submodules..."
(cd "$ROOT_DIR" && git submodule update --init --recursive)

# Backup non-symlink .zshrc if present
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    log_warn "Existing non-symlink ~/.zshrc found. Backing up to ~/.zshrc.bak..."
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# Stow active packages (fastfetch hypr kitty nvim ohmyzsh zsh)
log_info "Stowing user dotfiles..."
(cd "$ROOT_DIR" && stow --restow --verbose fastfetch hypr kitty nvim ohmyzsh zsh)

# ------------------------------------------------------------------------------
# PHASE 7: CORE SYSTEM SERVICES
# ------------------------------------------------------------------------------
print_header "PHASE 7: ENABLING CORE SERVICES"

sudo systemctl enable NetworkManager.service bluetooth.service || true
if systemctl list-unit-files | grep -q sddm.service; then
    sudo systemctl enable sddm.service || true
fi
systemctl --user enable pipewire.service wireplumber.service 2>/dev/null || true

print_header "🎉 DEPLOYMENT COMPLETE! SYSTEM READY 🎉"
