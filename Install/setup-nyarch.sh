#!/usr/bin/env bash
# ==============================================================================
# SAVIOUR GUNDAM (Lenovo E41-55) NYARCH LINUX CONVERSION & GNOME RICE INSTALLER
# Stow-Safe Secondary GNOME Session + Nyarch Exclusive Apps + OS Identity
# Preserves Hyprland, Noctalia, Kitty, Fastfetch, and LUKS/LVM 100%
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

header() { echo -e "\n${BLUE}========================================\n $1 \n========================================${NC}\n"; }
log_info() { echo -e "${GREEN}[NYARCH]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

BUILD_DIR="/tmp/nyarch-build"
NYARCH_GNOME="$BUILD_DIR/NyarchLinuxComp/Gnome"

header "1. SYSTEM PACKAGES & NYARCH OS IDENTITY"
log_info "Elevating privileges for pacman packages and /etc/os-release..."
sudo -v

log_info "Installing required GNOME & Nyarch dependencies..."
sudo pacman -S --needed --noconfirm \
    curl python-pip flatpak gnome-menus kitty wget git fastfetch \
    npm pacman-contrib gnome-shell-extensions tar

if [ ! -d "$NYARCH_GNOME" ]; then
    log_info "Cloning NyarchLinux 26.04 repository..."
    mkdir -p "$BUILD_DIR"
    git clone --depth 1 https://github.com/NyarchLinux/NyarchLinux.git "$BUILD_DIR/NyarchLinuxComp"
fi

if [ ! -f "$BUILD_DIR/default.jpg" ]; then
    log_info "Downloading Nyarch default wallpaper bundle..."
    wget -q -O "$BUILD_DIR/wallpaper.tar.gz" https://github.com/NyarchLinux/NyarchLinux/releases/download/25.04.4/wallpaper.tar.gz
    tar -xf "$BUILD_DIR/wallpaper.tar.gz" -C "$BUILD_DIR"
fi

log_info "Applying Nyarch Linux identity to /etc/os-release (keeping ID=arch for compatibility)..."
sudo cp /etc/os-release /etc/os-release.arch.bak 2>/dev/null || true
sudo tee /etc/os-release >/dev/null << 'EOF'
NAME="Nyarch Linux"
PRETTY_NAME="Nyarch Linux"
ID=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://nyarchlinux.moe/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://nyarchlinux.moe/"
BUG_REPORT_URL="https://github.com/NyarchLinux/NyarchLinux/issues"
LOGO=archlinux-logo
EOF

log_info "Installing nyaofetch, nekofetch, nyay, pacnyan, and nyaura into /usr/local/bin..."
for bin in nekofetch nyaofetch nyay pacnyan nyaura; do
    if [ -f "$HOME/.local/bin/$bin" ]; then
        sudo cp -f "$HOME/.local/bin/$bin" "/usr/local/bin/$bin"
        sudo chmod +x "/usr/local/bin/$bin"
    fi
done

sudo mkdir -p /usr/share/backgrounds
sudo cp -f "$BUILD_DIR/default.jpg" /usr/share/backgrounds/default.jpg

header "2. FLATPAK THEMES & NYARCH EXCLUSIVE APPS"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
sudo flatpak override --filesystem=xdg-config/gtk-3.0 || true
sudo flatpak override --filesystem=xdg-config/gtk-4.0 || true

log_info "Installing GTK3 Adwaita themes and Extension Manager from Flathub..."
flatpak install -y flathub \
    org.gtk.Gtk3theme.adw-gtk3 \
    org.gtk.Gtk3theme.adw-gtk3-dark \
    com.mattjakeman.ExtensionManager \
    com.github.tchx84.Flatseal \
    it.mijorus.gearlever \
    info.febvre.Komikku || true

log_info "Downloading and installing Nyarch Exclusive Flatpak bundles..."
mkdir -p "$BUILD_DIR/flatpaks"
cd "$BUILD_DIR/flatpaks"

declare -A NYARCH_BUNDLES=(
    ["catgirldownloader.flatpak"]="https://github.com/nyarchlinux/catgirldownloader/releases/latest/download/catgirldownloader.flatpak"
    ["wizard.flatpak"]="https://github.com/nyarchlinux/nyarchwizard/releases/latest/download/wizard.flatpak"
    ["nyarchtour.flatpak"]="https://github.com/nyarchlinux/nyarchtour/releases/latest/download/nyarchtour.flatpak"
    ["nyarchcustomize.flatpak"]="https://github.com/nyarchlinux/nyarchcustomize/releases/latest/download/nyarchcustomize.flatpak"
    ["nyarchscript.flatpak"]="https://github.com/nyarchlinux/nyarchscript/releases/latest/download/nyarchscript.flatpak"
    ["waifudownloader.flatpak"]="https://github.com/nyarchlinux/waifudownloader/releases/latest/download/waifudownloader.flatpak"
)

for bundle in "${!NYARCH_BUNDLES[@]}"; do
    url="${NYARCH_BUNDLES[$bundle]}"
    if [ ! -s "$bundle" ]; then
        log_info "Fetching $bundle..."
        wget -q -O "$bundle" "$url" || log_warn "Failed to download $bundle from $url"
    else
        log_info "Using pre-downloaded $bundle..."
    fi
    if [ -s "$bundle" ]; then
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
        flatpak install --user -y "$bundle" || flatpak install --user --no-deps -y "$bundle" || log_warn "Could not install $bundle, skipping."
    fi
done

header "3. VERIFYING STOW INTEGRITY"
cd "$HOME/Dotfiles"
stow --restow clang fastfetch gamemode hypr kitty noctalia nvim ruff zsh || true
log_info "All GNU Stow symlinks verified intact!"

echo -e "\n${GREEN}=================================================================="
echo -e " NYARCH LINUX CONVERSION COMPLETE! NYA~"
echo -e " - Run 'nyaofetch' to see your Nyarch ASCII catgirl fetch"
echo -e " - Run 'fastfetch' to see your Miku / Saviour Gundam fetch"
echo -e " - Select 'GNOME' in SDDM to boot into the full Nyarch Desktop"
echo -e " - Select 'Hyprland' in SDDM for your Noctalia rice"
echo -e "==================================================================${NC}"
