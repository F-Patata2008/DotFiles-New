#!/bin/bash

# ===================================================================================
# THE ULTIMATE DOTFILES INSTALLATION SCRIPT V3.0
# ===================================================================================

# --- SCRIPT CONFIGURATION AND SAFETY ---
set -e; set -u; set -o pipefail
cd "$(dirname "$0")" # Always run from the script's directory

# --- CONFIGURATION ---
readonly GITHUB_USER="F-Patata2008"
readonly STOW_PACKAGES=(fastfetch hypr i3 i3status kitty nvim ohmyzsh picom polybar rofi rofimoji swaylock wal waybar zsh)
readonly PERSONAL_REPOS=(Apunte Arduino-Codes Progra)
readonly SERVICES_TO_ENABLE=(
    NetworkManager.service
    bluetooth.service
    tlp.service
    fprintd.service
    cups.service
    powertop.service
    swayosd-libinput-backend.service # The new, crucial addition
)

# --- HELPER FUNCTIONS AND COLORS ---
readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}========================================\n $1 \n========================================${NC}\n"; }

# --- SCRIPT EXECUTION ---
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "STARTING FULL ARCH LINUX SYSTEM SETUP"

# --- FASE 0: PRE-FLIGHT CHECKS ---
print_header "FASE 0: PRE-FLIGHT CHECKS"
if ! ping -c 1 archlinux.org &> /dev/null; then
    echo -e "${RED}ERROR: No internet connection. Please connect to the internet and try again.${NC}"
    exit 1
fi
echo -e "${GREEN}✔️ Internet connection confirmed.${NC}"

# --- FASE 1: PACKAGE INSTALLATION (ROBUST METHOD) ---
print_header "FASE 1: INSTALLING PACMAN & AUR PACKAGES"
if ! grep -q "\[multilib\]" /etc/pacman.conf || grep -q "^#\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Syy
fi
echo "Installing packages from 'pacman_packages.txt' one by one..."
while read -r package; do
    if [[ -z "$package" || "$package" =~ ^# ]]; then continue; fi
    sudo pacman -S --needed --noconfirm "$package" || echo -e "${RED}--> FAILED to install '$package'. Continuing...${NC}"
done < pacman_packages.txt

if ! command -v yay &> /dev/null; then
    (cd .. && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay)
fi
yay -S --needed --noconfirm - < aur_packages.txt
echo -e "${GREEN}✔️ All packages installed successfully.${NC}"

# --- FASE 2: OH MY ZSH & POWERLEVEL10K ---
print_header "FASE 2: SETTING UP OH MY ZSH & POWERLEVEL10K"
git submodule update --init --recursive
P10K_DIR="../ohmyzsh/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
echo -e "${GREEN}✔️ Oh My Zsh & P10k are ready.${NC}"

# --- FASE 3: EXPERIMENTAL GOODIX FINGERPRINT FIRMWARE ---
print_header "FASE 3: OPTIONAL GOODIX FINGERPRINT FIRMWARE"
read -p "Do you want to install the Goodix fingerprint firmware? (y/n): " FINGERPRINT_CHOICE
if [[ "$FINGERPRINT_CHOICE" =~ ^[Yy]$ ]]; then
    ( # Run in a subshell to keep our main script clean
        cd /tmp
        git clone --recurse-submodules https://github.com/goodix-fp-linux-dev/goodix-fp-dump.git
        cd goodix-fp-dump
        python3 -m venv .venv
        source .venv/bin/activate
        pip install -r requirements.txt
        echo -e "${YELLOW}Please find your device's idProduct below:${NC}"
        sudo lsusb -vd "27c6:" | grep "idProduct"
        read -p "Enter the ID of your device (e.g., 55b4): " DEVICE_ID
        sudo .venv/bin/python3 run_"$DEVICE_ID".py
        deactivate
        rm -rf /tmp/goodix-fp-dump
    )
    echo -e "${GREEN}✔️ Firmware installation complete.${NC}"
else
    echo "Skipping fingerprint firmware installation."
fi

# --- FASE 4: SAFE SYSTEM CONFIGURATION ---
print_header "FASE 4: APPLYING SAFE SYSTEM CONFIGURATIONS"
echo "Setting TTY keymap to la-latin1..."
echo "KEYMAP=la-latin1" | sudo tee /etc/vconsole.conf

print_header "Enabling Fingerprint Authentication (PAM)"
FP_LINE="auth      sufficient      pam_fprintd.so"
for pam_file in sudo gdm-password polkit-1; do
    if ! grep -q "pam_fprintd.so" "/etc/pam.d/$pam_file"; then
        sudo sed -i "1s,^,$FP_LINE\n," "/etc/pam.d/$pam_file"
    fi
done
echo -e "${GREEN}✔️ Fingerprint authentication configured.${NC}"

# --- FASE 5: HARDWARE OPTIMIZATIONS ---
print_header "FASE 5: APPLYING HARDWARE OPTIMIZATIONS"
echo "Creating powertop auto-tune service..."
sudo tee /etc/systemd/system/powertop.service > /dev/null <<'EOF'
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
RemainAfterExit=no
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable powertop.service
echo -e "${GREEN}✔️ Powertop service created and enabled.${NC}"

# --- FASE 6: RESTORE THEMES & BOOT CONFIGS ---
print_header "FASE 6: RESTORING THEMES & BOOT CONFIGS"
if [ -d "system-files" ]; then
    sudo cp -r ./system-files/* /
    echo -e "${GREEN}✔️ System files restored.${NC}"
else
    echo -e "${YELLOW}Warning: 'system-files' directory not found. Skipping restore.${NC}"
fi

# --- FASE 7: ENABLING CORE SYSTEM SERVICES ---
print_header "FASE 7: ENABLING CORE SYSTEM SERVICES"
for service in "${SERVICES_TO_ENABLE[@]}"; do
    if ! sudo systemctl is-enabled --quiet "$service"; then
        echo "Enabling service: $service"
        sudo systemctl enable "$service"
    else
        echo "Service $service is already enabled."
    fi
done
echo -e "${GREEN}✔️ Core services enabled.${NC}"

# --- FASE 8: REBUILD SYSTEM IMAGES ---
print_header "FASE 8: REBUILDING SYSTEM IMAGES (GRUB & MKINITCPIO)"
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo -e "${GREEN}✔️ System images rebuilt successfully.${NC}"

# --- FASE 9: HYPRLAND PLUGINS ---
print_header "FASE 9: INSTALLING HYPRLAND PLUGINS"
if command -v hyprpm &> /dev/null; then
    HYPRPM_CONFIG="$HOME/.config/hypr/hyprpm.toml"
    mkdir -p "$(dirname "$HYPRPM_CONFIG")"
    tee "$HYPRPM_CONFIG" > /dev/null <<'EOF'
[hyprexpo]
source = "https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo"
EOF
    hyprpm update
    echo -e "${GREEN}✔️ Hyprland plugins updated.${NC}"
fi

# --- FASE 10: CLONE PERSONAL REPOSITORIES ---
print_header "FASE 10: CLONING PERSONAL REPOSITORIES"
for repo in "${PERSONAL_REPOS[@]}"; do
    if [ ! -d "$HOME/$repo" ]; then
        git clone "https://github.com/$GITHUB_USER/$repo.git" "$HOME/$repo"
        echo -e "${GREEN}✔️ Cloned '$repo' successfully.${NC}"
    fi
done

# --- FASE 11: APPLY USER DOTFILES WITH STOW ---
print_header "FASE 11: APPLYING USER DOTFILES WITH GNU STOW"
(cd .. && stow --restow --verbose "${STOW_PACKAGES[@]}")
echo -e "${GREEN}✔️ All user dotfiles have been stowed.${NC}"

# --- FASE 12: SET ZSH AS DEFAULT SHELL ---
print_header "FASE 12: SETTING ZSH AS DEFAULT SHELL"
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s "$(which zsh)"
    echo -e "${GREEN}✔️ Shell changed to Zsh.${NC}"
fi

print_header "🎉 INSTALLATION COMPLETE! 🎉"
echo "It is highly recommended to REBOOT NOW to apply all changes."
