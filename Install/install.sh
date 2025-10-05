#!/bin/bash

# ===================================================================================
# DOTFILES INSTALLATION SCRIPT (UPGRADED & SAFER)
# ===================================================================================

# --- SCRIPT CONFIGURATION AND SAFETY ---
set -e; set -u; set -o pipefail
cd "$(dirname "$0")" # Always run from the script's directory

# --- CONFIGURATION ---
readonly STOW_PACKAGES=(fastfetch hypr i3 i3status kitty nvim ohmyzsh picom polybar rofi rofimoji swaylock wal waybar zsh)

# --- HELPER FUNCTIONS AND COLORS ---
readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}========================================\n $1 \n========================================${NC}\n"; }

# --- SCRIPT EXECUTION ---
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "STARTING FULL ARCH LINUX SYSTEM SETUP"

# --- FASE 1 & 2: PACKAGE INSTALLATION ---
print_header "FASE 1 & 2: INSTALLING PACMAN & AUR PACKAGES"
# Enable multilib for Steam and 32-bit apps FIRST
if grep -q "^#\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Syy
else
    echo "Multilib repository is already enabled."
fi

echo "Installing packages from lists..."
sudo pacman -S --needed --noconfirm - < pacman_packages.txt
if ! command -v yay &> /dev/null; then
    echo "yay not found. Installing..."
    (cd .. && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay)
fi
yay -S --needed --noconfirm - < aur_packages.txt
echo -e "${GREEN}✔️ All packages installed successfully.${NC}"

# --- FASE 3: SAFE SYSTEM CONFIGURATION (THE MOST IMPORTANT PART) ---
print_header "FASE 3: APPLYING SAFE SYSTEM CONFIGURATIONS"

# Set TTY Keyboard Layout
echo "Setting TTY keymap to la-latin1..."
echo "KEYMAP=la-latin1" | sudo tee /etc/vconsole.conf

# SAFELY enable fingerprint authentication
print_header "Enabling Fingerprint Authentication (PAM)"
FP_LINE="auth      sufficient      pam_fprintd.so"

# For sudo
if ! grep -q "pam_fprintd.so" /etc/pam.d/sudo; then
    echo "Adding fingerprint auth to sudo..."
    sudo sed -i "1s,^,$FP_LINE\n," /etc/pam.d/sudo
else
    echo "Fingerprint auth for sudo already configured."
fi

# For GDM (graphical login)
if ! grep -q "pam_fprintd.so" /etc/pam.d/gdm-password; then
    echo "Adding fingerprint auth to GDM..."
    sudo sed -i "1s,^,$FP_LINE\n," /etc/pam.d/gdm-password
else
    echo "Fingerprint auth for GDM already configured."
fi

# For Polkit (graphical sudo prompts)
if ! grep -q "pam_fprintd.so" /etc/pam.d/polkit-1; then
    echo "Adding fingerprint auth to Polkit..."
    sudo sed -i "1s,^,$FP_LINE\n," /etc/pam.d/polkit-1
else
    echo "Fingerprint auth for Polkit already configured."
fi
echo -e "${GREEN}✔️ Fingerprint authentication configured.${NC}"

# --- FASE 4: RESTORE THEMES, HIBERNATION, AND OTHER SAFE FILES ---
print_header "FASE 4: RESTORING THEMES & BOOT CONFIGS"
# Here we copy files that are generally safe to overwrite.
# Create a 'system-files' directory in 'Install' and put your backups there.
echo "Copying GRUB, mkinitcpio, and theme files..."
sudo cp -r ../system-files/etc/* /etc/
sudo cp -r ../system-files/usr/* /usr/
sudo cp -r ../system-files/boot/* /boot/
echo -e "${GREEN}✔️ System files restored.${NC}"

# --- FASE 5: REBUILD SYSTEM IMAGES ---
print_header "FASE 5: REBUILDING SYSTEM IMAGES (GRUB & MKINITCPIO)"
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo -e "${GREEN}✔️ System images rebuilt successfully.${NC}"

# --- FASE 6: APPLY USER DOTFILES WITH STOW ---
print_header "FASE 6: APPLYING USER DOTFILES WITH GNU STOW"
cd .. # Go up to the root of the Dotfiles repo to run stow
echo "Stowing packages: ${STOW_PACKAGES[*]}"
stow --restow --verbose "${STOW_PACKAGES[@]}"
cd Install # Return to the install directory
echo -e "${GREEN}✔️ All user dotfiles have been stowed.${NC}"

# --- FASE 7: SET ZSH AS DEFAULT SHELL ---
print_header "FASE 7: SETTING ZSH AS DEFAULT SHELL"
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    echo -e "${GREEN}✔️ Shell changed to Zsh. Please log out and log back in for this to take effect.${NC}"
fi

print_header "🎉 INSTALLATION COMPLETE! 🎉"
echo "It is highly recommended to REBOOT NOW to apply all changes."
