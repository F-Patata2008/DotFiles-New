#!/bin/bash

# ===================================================================================
# THE DEFINITIVE DOTFILES INSTALLATION SCRIPT
#
# Combines a robust, interactive, phased approach with safe, surgical system edits.
# This script is the result of a difficult but successful system recovery.
# ===================================================================================

# --- SCRIPT CONFIGURATION AND SAFETY ---
set -e; set -u; set -o pipefail
cd "$(dirname "$0")" # Always run from the script's directory

# --- CONFIGURATION ---
readonly STOW_PACKAGES=(fastfetch hypr i3 i3status kitty nvim ohmyzsh picom polybar rofi rofimoji swaylock wal waybar zsh)

# --- HELPER FUNCTIONS AND COLORS ---
readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}========================================\n $1 \n========================================${NC}\n"; }
command_exists() { command -v "$1" &> /dev/null; }

# --- SCRIPT EXECUTION ---
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "STARTING FULL ARCH LINUX SYSTEM SETUP"

# --- FASE 1: PACMAN DEPENDENCIES (ROBUST METHOD) ---
print_header "FASE 1: INSTALLING PACMAN PACKAGES"
if ! grep -q "^#\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Syy
fi
echo "Installing packages from 'pacman_packages.txt' one by one..."
while read -r package; do
    # Skip empty lines and comments
    if [[ -z "$package" || "$package" =~ ^# ]]; then continue; fi
    echo -e "${GREEN}--> Installing '$package'...${NC}"
    sudo pacman -S --needed --noconfirm "$package" || echo -e "${RED}--> FAILED to install '$package'. Continuing...${NC}"
done < pacman_packages.txt
echo -e "${GREEN}✔️ Pacman packages installed.${NC}"

# --- FASE 2: AUR DEPENDENCIES (YAY) ---
print_header "FASE 2: INSTALLING AUR PACKAGES WITH YAY"
if ! command_exists yay; then
    echo "yay not found. Installing..."
    (cd .. && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay)
fi
echo "Installing AUR packages from 'aur_packages.txt'..."
yay -S --needed --noconfirm - < aur_packages.txt
echo -e "${GREEN}✔️ AUR packages installed.${NC}"

# --- FASE 3: OH MY ZSH & POWERLEVEL10K ---
print_header "FASE 3: SETTING UP OH MY ZSH & POWERLEVEL10K"
git submodule update --init --recursive # Ensures ohmyzsh is cloned
P10K_DIR="../ohmyzsh/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Cloning Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
echo -e "${GREEN}✔️ Oh My Zsh & P10k are ready.${NC}"

# --- FASE 4: EXPERIMENTAL GOODIX FINGERPRINT FIRMWARE ---
print_header "FASE 4: OPTIONAL GOODIX FINGERPRINT FIRMWARE"
read -p "Do you want to install the Goodix fingerprint firmware? (y/n): " FINGERPRINT_CHOICE
if [[ "$FINGERPRINT_CHOICE" =~ ^[Yy]$ ]]; then
    echo "Starting firmware installation..."
    cd /tmp # Use a temporary directory
    git clone --recurse-submodules https://github.com/goodix-fp-linux-dev/goodix-fp-dump.git
    cd goodix-fp-dump
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    
    echo -e "${YELLOW}Please find your device's idProduct below:${NC}"
    sudo lsusb -vd "27c6:" | grep "idProduct"
    read -p "Enter the ID of your device (e.g., 55b4): " DEVICE_ID

    echo "Running firmware installation script..."
    # The crucial fix: run python from within the venv using sudo
    sudo .venv/bin/python3 run_"$DEVICE_ID".py
    
    deactivate
    cd /tmp
    rm -rf goodix-fp-dump
    echo -e "${GREEN}✔️ Firmware installation complete. You must enroll your fingerprints after reboot.${NC}"
else
    echo "Skipping fingerprint firmware installation."
fi
# Return to the script directory
cd "$HOME/Dotfiles/Install"

# --- FASE 5: SAFE SYSTEM CONFIGURATION ---
print_header "FASE 5: APPLYING SAFE SYSTEM CONFIGURATIONS"
echo "Setting TTY keymap to la-latin1..."
echo "KEYMAP=la-latin1" | sudo tee /etc/vconsole.conf

print_header "Enabling Fingerprint Authentication (PAM)"
FP_LINE="auth      sufficient      pam_fprintd.so"
for pam_file in sudo gdm-password polkit-1; do
    if ! grep -q "pam_fprintd.so" "/etc/pam.d/$pam_file"; then
        echo "Adding fingerprint auth to $pam_file..."
        sudo sed -i "1s,^,$FP_LINE\n," "/etc/pam.d/$pam_file"
    fi
done
echo -e "${GREEN}✔️ Fingerprint authentication configured.${NC}"

# --- FASE 6: RESTORE THEMES & BOOT CONFIGS ---
print_header "FASE 6: RESTORING THEMES & BOOT CONFIGS"
echo "Copying GRUB, mkinitcpio, and other safe system files..."
# This assumes your backed-up files are in a 'system-files' directory
if [ -d "system-files" ]; then
    sudo cp -r ./system-files/etc/* /etc/
    sudo cp -r ./system-files/usr/* /usr/
    sudo cp -r ./system-files/boot/* /boot/
    echo -e "${GREEN}✔️ System files restored.${NC}"
else
    echo -e "${YELLOW}Warning: 'system-files' directory not found. Skipping restore.${NC}"
fi

# --- FASE 7: REBUILD SYSTEM IMAGES ---
print_header "FASE 7: REBUILDING SYSTEM IMAGES (GRUB & MKINITCPIO)"
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo -e "${GREEN}✔️ System images rebuilt successfully.${NC}"

# --- FASE 8: HYPRLAND PLUGINS (HYPREXPO) ---
print_header "FASE 8: INSTALLING HYPRLAND PLUGINS"
if command -v hyprpm &> /dev/null; then
    HYPR_CONFIG_DIR="$HOME/.config/hypr"
    HYPRPM_CONFIG="$HYPR_CONFIG_DIR/hyprpm.toml"
    mkdir -p "$HYPR_CONFIG_DIR"
    tee "$HYPRPM_CONFIG" > /dev/null <<'EOF'
[hyprexpo]
source = "https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo"
EOF
    echo "Running hyprpm to update and build plugins..."
    hyprpm update
    echo -e "${GREEN}✔️ Hyprland plugins updated.${NC}"
else
    echo -e "${YELLOW}Warning: hyprpm not found. Skipping plugin install.${NC}"
fi

# --- FASE 9: APPLY USER DOTFILES WITH STOW ---
print_header "FASE 9: APPLYING USER DOTFILES WITH GNU STOW"
cd .. # Go up to the root of the Dotfiles repo to run stow
echo "Stowing packages: ${STOW_PACKAGES[*]}"
stow --restow --verbose "${STOW_PACKAGES[@]}"
cd Install # Return to the install directory
echo -e "${GREEN}✔️ All user dotfiles have been stowed.${NC}"

# --- FASE 10: SET ZSH AS DEFAULT SHELL ---
print_header "FASE 10: SETTING ZSH AS DEFAULT SHELL"
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    echo -e "${GREEN}✔️ Shell changed to Zsh.${NC}"
fi

print_header "🎉 INSTALLATION COMPLETE! 🎉"
echo "It is highly recommended to REBOOT NOW to apply all changes."
