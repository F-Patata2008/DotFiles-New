# Arch Setup
Hello, I use Arch (BTW), with Hyprland and Gnome + GDM, mostly Hyprland, but sometimes Gnome.

I do prefer Gnome's Aesthetic, but i do like KDE better customization and integration.

I mostly use Hyprland for my day to day tasks, as it suits better my own workflow, but when I need to do things without much hassle, I logout and login into Gnome.

## My machine spec are as following:
- **Model:** Lenovo E41-55
- **RAM:** 2 x 8 DDR4 3200 SODDIM Memory + 16 GB Swap
- **Processor:** Ryzen 3 3250U 2 Cores 4 Threads
- **GPU:** Vega 3 Integrated Graphics
- **SSD:** 500 GB M2 NVME Gen 3 WD Black
- **Screen:** 1366x768 14", 60 Hz
- **Fingerprint Reader:** 27c6:55b4 Shenzhen Goodix Technology Co.,Ltd. Fingerprint Reader

## Current System Setup
I do have my Hyprland setup for my own workflow, wich includes the following:

- **Mobile integration:** I use KDE Connect, but have some issues
wich will be detailed later in the file.
- **Dotfiles + Stow:** My config makes use of the stow functionality, so I have everything all in one place, wich is my ~/Dotfiles/ folder, wich is also a github repository

- **Batery and suspension optimizations:** Another parat of my configuration, is tshe ability to hiberante and suspend to RAM, wich allows me to, after 15 minutes idling, at least in my Hyprland session, my pc suspends to RAM, and procceds to shutdown

- **Plymouth and Grub Themes:** A big part of my customization are teh Grub and Plymouth Themes, wich correpond to Minecarft 1.16 and Minecraft world loading screen respectively.

- **I use the Hypr suite of addons:** My config makes use of the Hypr suite, plus some addons, wich includes
    - HyprSunset
    - HyprIdle
    - HyprLock
    - HyprPaper
    - HyprShot
    - Kitty
    - Waybar
    - Wal
    - Opera
    - Neovim
    - Rofi
    - Clipse
    - SwayOSD
    - SwayNC
    - Some Gnome Apps

- **Gnome:** All of Gnome Circle and Extra, no Gnome Dev apps

- **LVM:** My setup makes use of LVM for better partition sizing and mounting, plus better rezing and less hassle with ssd blocks


### My Dotfiles Structure
.
├── eww
├── fastfetch
├── hypr
├── i3
├── i3status
├── Install
│   └── system-files
│       ├── boot
│       │   └── grub
│       │       └── themes
│       │           └── minegrub
│       │               ├── assets
│       │               └── backgrounds
│       ├── etc
│       │   ├── cron.d
│       │   ├── cups
│       │   │   └── ppd
│       │   ├── default
│       │   ├── systemd
│       │   │   └── system
│       │   ├── udev
│       │   │   └── rules.d
│       │   └── ufw
│       │       └── applications.d
│       └── usr
│           ├── local
│           │   └── bin
│           └── share
│               └── plymouth
│                   └── themes
│                       └── mc
├── kitty
├── nvim
├── ohmyzsh
├── picom
├── polybar
├── rofi
├── rofimoji
├── screenshots
├── swaylock
├── swaync
├── wal
├── Wallpapers
│   ├── Gundam
│   └── Macross
├── waybar
├── wlogout
└── zsh
49 Directories



## What I want to achieve:

- **Better Phone Integration:** As I said earlier, I use KDE Connect for connecting my phone to my PC, but I ran into some issues:
    1. I can not answer messages (RCS/SMS) or calls while on Hyprland
    1. When I need to acces my phone filesystem remotly (not cable thetered), I could not acces the drive, as Gnome's Nautilus did not recognize it, so I proceed to install Dolphin (KDE's file manager), wich promptlu recognized the drive. This solution is far form idea, as I do like to use Gnome's App suite (Extra and Core).
    1. I can not monitor my phone's battery while on my pc, and I would love for it to show on my Waybar when I hover my battery module, rigth under Time to empty
- **WhatsApp:** I know I can exceute the WhatsApp Desktop App using a VM, but should I use a VM, Winboat, or Wine, because im rather tired of using Opera's integrated WhatsApp tab, or before, having a dedicated tab, in a dedicated workpsace for WhatsApp in Firefox
- **App Recomedations:** I included the list of installed apps and functionalitys, and wich would you recommend I use for a better system, my objetcive being a config like HyDE or Omarchy
    - **I need better hardware compatibilty**
    - **Workflow**
    - **Aesthetics:** Better aesthetcis, but maintaing my theme based on Tokyo Nigth and abit of Catpuccin

- **Install Script Polishing** In a few months, when I enter Univeristy, I'm supposed to change pc (I haven't decided yet, but im between a Legion 5 and a Lenovo LOQ with same GPU, and an EDC, like a Thinkpad T14, HP Envy or ASUS Vivo and ZEN book), with the objective being to esaily move my config to this new pc, and adapt it for its own needs, like ditching the fingerprint sensor if the pc does not include one
    - It needs to be clone and execute, but having in consideration i will modify files leater to suit the screen size and type
    - Maintain themes and general configs
    - Install my Apps
    - Install my packages
    - Install Spotify from AUR
    - Setup Spicetify from AUR
    - Setup Spicetify Marketplace
    - Install yay
    - Change shell to ZSH
    - Install Oh My ZSH
    - Install P10k
    - Set Latin America keymap
    - Detect if PC has fingerprint reader, and if its the shezen 27c6:55b4, install its comunity experimental driver
    - Setup Pam.d if pc has fingerprint reader
    - Activate hiberantion
    - Set Plymouth Theme
    - Set Grub Theme
    - Set Printers, especially HP-Deksjet 1615 I believe
    - Enable services:
        - Bluetooth
        - Fingerprint in case pc has
        - TLP (for power managment)
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

```
## My dotfiles repo:
https://github.com/F-Patata2008/DotFiles-New
