#!/bin/bash

# ===================================================================================
# DOTFILES INSTALLATION SCRIPT (REFACTORED)
#
# This script is designed to be robust, configurable, and easy to maintain.
# It sets up an Arch Linux environment by installing packages, themes, and
# dotfiles using GNU Stow.
#
# Changes from original:
#   - Fails on any error (`set -e`) to prevent partial installs.
#   - Central configuration section for easy edits.
#   - Package lists are read from external files for clarity.
#   - Colored output and helper functions for readability.
#   - Idempotency checks to make the script safely re-runnable.
# ===================================================================================

# --- SCRIPT CONFIGURATION AND SAFETY ---

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipelines fail if any command in the pipeline fails, not just the last one.
set -o pipefail

# --- CONFIGURATION (EDIT THESE VALUES) ---

# Your GitHub username for cloning personal repositories
readonly GITHUB_USER="F-Patata2008"

# List of all dotfile directories to be managed by GNU Stow
readonly STOW_PACKAGES=(
    fastfetch
    hypr
    i3
    i3status
    kitty
    nvim
    ohmyzsh
    picom
    polybar
    rofi
    rofimoji
    swaylock
    wal
    waybar
    zsh
)

# Your personal repositories to clone into the home directory
readonly PERSONAL_REPOS=(
    "Apunte"
    "Arduino-Codes"
    "Progra"
)

# --- HELPER FUNCTIONS AND COLORS ---

# Define color codes for script output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Prints a formatted header message.
# Usage: print_header "My Header Message"
print_header() {
    echo -e "\n${YELLOW}=======================================================================${NC}"
    echo -e "${YELLOW} $1 ${NC}"
    echo -e "${YELLOW}=======================================================================${NC}\n"
}

# Checks if a command exists.
# Usage: command_exists "git"
command_exists() {
    command -v "$1" &> /dev/null
}

# --- SCRIPT EXECUTION ---

# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

print_header "STARTING ARCH LINUX DOTFILES INSTALLATION"
echo "This script will install packages, clone repositories, and set up your dotfiles."
echo "You will be prompted for input at several stages."

# --- FASE 1: PACMAN DEPENDENCIES ---
print_header "FASE 1: INSTALLING PACMAN PACKAGES"
if [ ! -f "pacman_packages.txt" ]; then
    echo -e "${RED}ERROR: 'pacman_packages.txt' not found. Please create it.${NC}"
    exit 1
fi
echo "Updating system and installing packages from 'pacman_packages.txt'..."
sudo pacman -Syu --needed --noconfirm - < pacman_packages.txt
echo -e "${GREEN}✔️ Pacman packages installed successfully.${NC}"


# --- FASE 2: AUR DEPENDENCIES (YAY) ---
print_header "FASE 2: INSTALLING AUR PACKAGES WITH YAY"
if ! command_exists yay; then
    echo "'yay' not found. Installing..."
    git clone https://aur.archlinux.org/yay.git
    (cd yay && makepkg -si --noconfirm)
    rm -rf yay
    echo -e "${GREEN}✔️ yay installed successfully.${NC}"
else
    echo "yay is already installed. Syncing packages..."
fi

if [ ! -f "aur_packages.txt" ]; then
    echo -e "${RED}ERROR: 'aur_packages.txt' not found. Please create it.${NC}"
    exit 1
fi
echo "Installing AUR packages from 'aur_packages.txt'..."
yay -S --needed --noconfirm - < aur_packages.txt
echo -e "${GREEN}✔️ AUR packages installed successfully.${NC}"

# --- FASE 3: GIT SUBMODULES (OH-MY-ZSH) ---
print_header "FASE 3: UPDATING GIT SUBMODULES"
echo "Initializing and updating Git submodules (oh-my-zsh)..."
git submodule update --init --recursive
echo -e "${GREEN}✔️ Git submodules are up to date.${NC}"

# --- FASE 4: POWERLEVEL10K THEME ---
print_header "FASE 4: INSTALLING POWERLEVEL10K THEME"
P10K_DIR="ohmyzsh/.oh-my-zsh/custom/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    echo "Powerlevel10k is already installed. Skipping."
else
    echo "Cloning Powerlevel10k repository..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    echo -e "${GREEN}✔️ Powerlevel10k installed successfully.${NC}"
fi

# --- FASE 5: OPTIONAL THEMES (PLYMOUTH & GRUB) ---
print_header "FASE 5: INSTALLING EXTRA THEMES"
read -p "Do you want to install the Minecraft Plymouth and GRUB themes? (y/n): " THEME_CHOICE
if [[ "$THEME_CHOICE" =~ ^[Yy]$ ]]; then
    echo "Installing Minecraft Plymouth theme..."
    git clone https://github.com/nikp123/minecraft-plymouth-theme.git
    (cd minecraft-plymouth-theme && sudo ./install.sh)
    rm -rf minecraft-plymouth-theme
    echo -e "${GREEN}✔️ Plymouth theme installed. Run 'sudo plymouth-set-default-theme -R minecraft-theme' to apply.${NC}"

    echo "Installing Minegrub theme..."
    git clone https://github.com/Lxtharia/minegrub-theme.git
    (cd minegrub-theme && sudo ./install.sh)
    rm -rf minegrub-theme
    echo -e "${GREEN}✔️ GRUB theme installed. Remember to run 'sudo grub-mkconfig -o /boot/grub/grub.cfg'.${NC}"
else
    echo "Skipping optional theme installation."
fi

# --- FASE 6: OPTIONAL FINGERPRINT FIRMWARE ---
print_header "FASE 6: OPTIONAL GOODIX FINGERPRINT FIRMWARE"
read -p "Do you want to install the Goodix fingerprint firmware? (y/n): " FINGERPRINT_CHOICE
if [[ "$FINGERPRINT_CHOICE" =~ ^[Yy]$ ]]; then
    echo "Starting firmware installation..."
    git clone --recurse-submodules https://github.com/goodix-fp-linux-dev/goodix-fp-dump.git
    cd goodix-fp-dump
    echo "Setting up Python virtual environment..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    
    echo -e "${YELLOW}Please find your device's idProduct below:${NC}"
    sudo lsusb -vd "27c6:" | grep "idProduct"
    read -p "Enter the ID of your device (e.g., 55b4): " DEVICE_ID

    echo "Running firmware installation script..."
    sudo python3 run_5110.py --id "$DEVICE_ID"
    
    deactivate
    cd ..
    rm -rf goodix-fp-dump
    echo -e "${GREEN}✔️ Firmware installation complete.${NC}"
else
    echo "Skipping fingerprint firmware installation."
fi

# --- FASE 7: CLONE PERSONAL REPOS ---
print_header "FASE 7: CLONING PERSONAL REPOSITORIES"
for repo in "${PERSONAL_REPOS[@]}"; do
    if [ -d "$HOME/$repo" ]; then
        echo "Repository '$repo' already exists. Skipping."
    else
        echo "Cloning $GITHUB_USER/$repo..."
        git clone "https://github.com/$GITHUB_USER/$repo.git" "$HOME/$repo"
        echo -e "${GREEN}✔️ Cloned '$repo' successfully.${NC}"
    fi
done

# --- FASE 8: APPLY DOTFILES WITH STOW ---
print_header "FASE 8: APPLYING DOTFILES WITH GNU STOW"
echo "The following packages will be symlinked to your home directory:"
printf "  %s\n" "${STOW_PACKAGES[@]}"
read -p "Do you want to proceed? (y/n): " STOW_CHOICE
if [[ "$STOW_CHOICE" =~ ^[Yy]$ ]]; then
    for package in "${STOW_PACKAGES[@]}"; do
        if [ -d "$package" ]; then
            echo "Stowing '$package'..."
            stow --restow --verbose "$package"
            echo -e "${GREEN}✔️ '$package' stowed successfully.${NC}"
        else
            echo -e "${YELLOW}Warning: Directory for stow package '$package' not found. Skipping.${NC}"
        fi
    done
else
    echo "Stow process skipped."
fi

# --- FASE 9: SET ZSH AS DEFAULT SHELL ---
print_header "FASE 9: SETTING ZSH AS DEFAULT SHELL"
if [[ "$SHELL" != "/bin/zsh" ]]; then
    echo "Changing default shell to Zsh for user $(whoami)..."
    chsh -s "$(which zsh)"
    echo -e "${GREEN}✔️ Shell changed to Zsh. Please log out and log back in for this to take effect.${NC}"
else
    echo "Zsh is already the default shell."
fi

# --- FASE 10: POST-INSTALLATION INSTRUCTIONS ---
print_header "🎉 INSTALLATION COMPLETE! 🎉"
echo "Your new environment is almost ready. Please complete these final steps:"
echo "  1. ${YELLOW}REBOOT YOUR SYSTEM${NC} to apply all changes (especially for the shell and kernel modules)."
echo "  2. After rebooting, open a new Zsh terminal and run ${GREEN}'p10k configure'${NC} to set up your prompt."
echo "  3. To apply themes, remember to run the Plymouth and GRUB update commands mentioned earlier."
echo "  4. Run ${GREEN}'wal -i /path/to/your/wallpaper.jpg'${NC} to set your wallpaper and initial color scheme."
echo -e "\nEnjoy your new setup!"
