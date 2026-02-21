#!/bin/bash
# ==============================================================================
# CORE DOTFILES INSTALLATION SCRIPT V5.0 (Hardware Agnostic)
# ==============================================================================

set -e; set -u; set -o pipefail
cd "$(dirname "$0")"

readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}========================================\n $1 \n========================================${NC}\n"; }
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "FASE 1: HARDWARE & PROFILE DETECTION"
echo "Select your GPU Driver profile:"
echo "1) AMD (Radeon/Vega)"
echo "2) NVIDIA (Proprietary)"
echo "3) Intel / VM (Basic)"
read -p "Selection [1-3]: " GPU_SEL

echo -e "\nSelect your Machine Profile:"
echo "1) Lenovo E41-55 (Applies TLP, Goodix Fingerprint, mkinitcpio tweaks)"
echo "2) Generic PC / ThinkPad P1 (Skips hardware-specific hacks)"
read -p "Selection [1-2]: " MACH_SEL

print_header "FASE 2: PACKAGE INSTALLATION"
# Enable multilib
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Sy
fi

# Install yay
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    (cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && rm -rf /tmp/yay)
fi

log_info "Installing Base Packages..."
# NOTE: You will need to split your pacman-all.txt into base, hyprland, etc.
sudo pacman -S --needed --noconfirm - < pkgs/pacman-all.txt || true
yay -S --needed --noconfirm - < pkgs/aur-all.txt || true

if [ "$GPU_SEL" == "1" ]; then
    sudo pacman -S --needed --noconfirm xf86-video-amdgpu vulkan-radeon libva-mesa-driver
elif [ "$GPU_SEL" == "2" ]; then
    sudo pacman -S --needed --noconfirm nvidia-dkms nvidia-utils egl-wayland
fi

print_header "FASE 3: ZSH & POWERLEVEL10K"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
chsh -s "$(which zsh)"

print_header "FASE 4: COMMON SYSTEM FILES"
log_info "Copying universal system configurations (GRUB, SDDM, Pacman)..."
sudo cp -rT ./system-files/common/ /

print_header "FASE 5: MACHINE SPECIFIC PROFILES"
if [ "$MACH_SEL" == "1" ]; then
    log_info "Executing Lenovo E41-55 specific setup..."
    bash ./profiles/Lenovo.sh
else
    log_info "Generic profile selected. Skipping hardware hacks."
fi

print_header "FASE 6: GNU STOW"
(cd .. && stow --restow --verbose fastfetch hypr kitty nvim ohmyzsh systemd zsh)

print_header "FASE 7: ENABLING CORE SERVICES"
sudo systemctl enable NetworkManager.service bluetooth.service sddm.service
systemctl --user enable pipewire.service wireplumber.service

print_header "🎉 CORE INSTALLATION COMPLETE! REBOOT REQUIRED 🎉"
