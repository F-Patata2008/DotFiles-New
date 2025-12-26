- **Install Script Polishing** In a few months, when I enter Univeristy, I'm supposed to change pc (I haven't decided yet, but im between a Legion 5 and a Lenovo LOQ with same GPU, and an EDC, like a Thinkpad T14, HP Envy or ASUS Vivo and ZEN book), with the objective being to esaily move my config to this new pc, and adapt it for its own needs, like ditching the fingerprint sensor if the pc does not include one
    - It needs to be clone and execute, but having in consideration i will modify files leater to suit the screen size and type
    - Maintain themes and general configs
    - Install my Apps
    - Install my packages
    - Install Spotify from AUR
    - Setup Spicetify from AUR
    - Setup Spicetify Marketplace
    - Install yay
    -Chnage mirrors to chile, brazil, argentina, peru, for latest and fastets mirrors
    - Change shell to ZSH
    - Install Oh My ZSH
    - Install P10k
    - Actuvate UFW firewall
    - Update and install Microcode
    - Set Latin America keymap
    - Detect if PC has fingerprint reader, and if its the shezen 27c6:55b4, install its comunity experimental driver, wich is both a python install + AUR package
    - Setup Jetbrains Mono font
    - Setup Pam.d if pc has fingerprint reader
    - Activate hiberantion
    - Activate Swap
    - Set Plymouth Theme
    - Set Grub Theme
    - Set Printers, especially HP-Deksjet 1515, both for scanning and printing
    - Enable services:
        - Bluetooth
        - Fingerprint in case pc has
        - TLP (for power managment)
        - SDDM
        - Network Manager
        - Cups
        - Powertop
        - SwayOSD
    - No hyprland plugins
    - Clone Personal Repos:
        - Apuntes
        - Progra
        - Arduino
        - Profile
    - Stow configs
    - Setupt battery monitor (I have a cron job for it in sys-files)
    - Log errors in case of a failed installtion

## Curent Install Script
My current installation script afetr migrating, its deficient, it does not chek if an app is alredy install and if so, skips it, does not install ohmyzsh, and other minor things that do not allow for a correct migration

```Install.sh
#!/bin/bash

# ===================================================================================
# THE ULTIMATE DOTFILES INSTALLATION SCRIPT V4.0
# Author: F-Patata2008, with revisions by your AI assistant
# ===================================================================================

# --- SCRIPT CONFIGURATION AND SAFETY ---
set -e; set -u; set -o pipefail
# Ensure the script is run from the 'Install' directory within Dotfiles
cd "$(dirname "$0")"
readonly LOG_FILE="$PWD/install_log_$(date +%F_%H-%M-%S).txt"
exec > >(tee -a "$LOG_FILE") 2>&1 # Redirect all output to log file and stdout

# --- CONFIGURATION ---
readonly GITHUB_USER="F-Patata2008"
readonly STOW_PACKAGES=(fastfetch hypr i3 i3status kitty nvim ohmyzsh picom polybar rofi rofimoji swaylock wal waybar zsh)
readonly PERSONAL_REPOS=(Apunte Progra Arduino-Codes F-Patata2008) # Corrected repo names
readonly SERVICES_TO_ENABLE=(
    NetworkManager.service bluetooth.service tlp.service cups.service
    powertop.service swayosd-libinput-backend.service check-bat.timer
)

# --- HELPER FUNCTIONS AND COLORS ---
readonly GREEN='\033[0;32m'; readonly RED='\033[0;31m'; readonly YELLOW='\033[1;33m'; readonly NC='\033[0m'
print_header() { echo -e "\n${YELLOW}========================================\n $1 \n========================================${NC}\n"; }
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- SCRIPT EXECUTION ---
# Request sudo privileges upfront and keep them alive.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "STARTING FULL ARCH LINUX SYSTEM SETUP"
log_info "Full installation log will be saved to: $LOG_FILE"

# --- FASE 0: PRE-FLIGHT CHECKS ---
print_header "FASE 0: PRE-FLIGHT CHECKS"
if ! ping -c 1 archlinux.org &> /dev/null; then
    log_error "No internet connection. Please connect and try again."
    exit 1
fi
log_info "✔️ Internet connection confirmed."

# --- FASE 1: PACKAGE INSTALLATION ---
print_header "FASE 1: INSTALLING PACMAN & AUR PACKAGES"
if ! grep -q "\[multilib\]" /etc/pacman.conf || grep -q "^#\[multilib\]" /etc/pacman.conf; then
    log_info "Enabling multilib repository..."
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Syy
fi

log_info "Installing Pacman packages..."
sudo pacman -S --needed --noconfirm - < pacman_packages.txt || log_warn "Some pacman packages failed to install. Check the log."

log_info "Installing or updating yay..."
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    (cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd / && rm -rf /tmp/yay)
fi

log_info "Installing AUR packages..."
yay -S --needed --noconfirm - < aur_packages.txt || log_warn "Some AUR packages failed to install. Check the log."
log_info "✔️ All packages installed."

# --- FASE 2: SPICETIFY SETUP ---
print_header "FASE 2: SETTING UP SPICETIFY"
if command -v spicetify &> /dev/null; then
    log_info "Configuring Spicetify..."
    sudo chmod a+wr /opt/spotify/Apps -R
    spicetify backup apply
    log_info "Installing Spicetify Marketplace..."
    (cd "$(spicetify -c | grep 'Custom apps')/.." && curl -fL "https://github.com/spicetify/spicetify-marketplace/releases/latest/download/spicetify-marketplace.zip" -o spicetify-marketplace.zip && unzip -o spicetify-marketplace.zip)
    spicetify apply
    log_info "✔️ Spicetify setup complete."
else
    log_warn "Spicetify not found. Skipping setup."
fi

# --- FASE 3: ZSH, OH MY ZSH & POWERLEVEL10K ---
print_header "FASE 3: SETTING UP ZSH & POWERLEVEL10K"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Oh My Zsh not found, installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log_info "Oh My Zsh already installed."
fi
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    log_info "Cloning Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
if [[ "$SHELL" != "/bin/zsh" ]]; then
    log_info "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
fi
log_info "✔️ Zsh setup complete."

# --- FASE 4: CONDITIONAL FINGERPRINT SETUP ---
print_header "FASE 4: FINGERPRINT READER CONFIGURATION"
FINGERPRINT_ID="27c6:55b4"
if lsusb | grep -q "$FINGERPRINT_ID"; then
    log_info "Goodix $FINGERPRINT_ID fingerprint reader detected."
    read -p "Do you want to install the experimental community driver? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        yay -S --needed --noconfirm libfprint-goodixtls-55x4
        log_info "Enabling fingerprint authentication (PAM)..."
        FP_LINE="auth      sufficient      pam_fprintd.so"
        for pam_file in sudo gdm-password polkit-1; do
            if ! grep -q "pam_fprintd.so" "/etc/pam.d/$pam_file"; then
                sudo sed -i "1s,^,$FP_LINE\n," "/etc/pam.d/$pam_file"
                log_info "Patched /etc/pam.d/$pam_file"
            fi
        done
        sudo systemctl enable fprintd.service
        log_info "✔️ Fingerprint setup complete. Please enroll your fingerprints after reboot with 'fprintd-enroll'."
    else
        log_warn "Skipping fingerprint driver installation."
    fi
else
    log_info "No Goodix $FINGERPRINT_ID reader detected. Skipping."
fi

# --- FASE 5: SYSTEM CONFIGURATION & THEMES ---
print_header "FASE 5: APPLYING SYSTEM CONFIGS, THEMES & OPTIMIZATIONS"
log_info "Copying system-wide files (GRUB, Plymouth, services, etc.)..."
if [ -d "system-files" ]; then
    sudo cp -rT ./system-files/ / # -T treats source as a file, copying its contents
    log_info "✔️ System files restored."
else
    log_error "'system-files' directory not found. Cannot proceed with critical configs."
    exit 1
fi
log_info "Setting TTY keymap to la-latin1..."
sudo localectl set-keymap la-latin1
log_info "Setting Plymouth theme..."
sudo plymouth-set-default-theme -R minecraft-theme || log_warn "Failed to set Plymouth theme."
log_info "✔️ System configuration applied."

# --- FASE 6: ENABLING SYSTEM SERVICES ---
print_header "FASE 6: ENABLING CORE SYSTEM SERVICES"
for service in "${SERVICES_TO_ENABLE[@]}"; do
    if ! sudo systemctl is-enabled --quiet "$service"; then
        log_info "Enabling service: $service"
        sudo systemctl enable "$service"
    else
        log_info "Service $service is already enabled."
    fi
done
log_info "✔️ Core services enabled."

# --- FASE 7: REBUILD SYSTEM IMAGES ---
print_header "FASE 7: REBUILDING SYSTEM IMAGES (GRUB & MKINITCPIO)"
log_info "Updating initramfs..."
sudo mkinitcpio -P
log_info "Updating GRUB configuration..."
sudo grub-mkconfig -o /boot/grub/grub.cfg
log_info "✔️ System images rebuilt successfully."

# --- FASE 8: CLONE PERSONAL REPOSITORIES ---
print_header "FASE 8: CLONING PERSONAL REPOSITORIES"
mkdir -p "$HOME/Progra" "$HOME/Arduino" # Ensure parent directories exist
for repo in "${PERSONAL_REPOS[@]}"; do
    # Handle specific target directories
    TARGET_DIR="$HOME"
    if [[ "$repo" == "Progra" || "$repo" == "Arduino" ]]; then
        TARGET_DIR="$HOME/$repo"
    fi

    if [ ! -d "$TARGET_DIR/$(basename $repo)" ]; then
        log_info "Cloning '$repo'..."
        git clone "https://github.com/$GITHUB_USER/$repo.git" "$TARGET_DIR/$(basename $repo)"
    else
        log_info "Repository '$repo' already exists. Skipping."
    fi
done

# --- FASE 9: APPLY USER DOTFILES WITH STOW ---
print_header "FASE 9: APPLYING USER DOTFILES WITH GNU STOW"
log_info "This will overwrite existing configs in your home directory."
# Navigate to the parent directory of 'Install' to run stow
(cd .. && stow --restow --verbose "${STOW_PACKAGES[@]}")
log_info "✔️ All user dotfiles have been stowed."

# --- FASE 10: Final Steps ---
print_header "🎉 INSTALLATION COMPLETE! 🎉"
log_info "It is highly recommended to REBOOT NOW to apply all changes."
log_info "After reboot, remember to:"
log_info "  - Run 'fprintd-enroll' to add your fingerprints."
log_info "  - Launch Spotify once to let Spicetify finish its setup."
log_info "  - Enjoy your new system!"

```

