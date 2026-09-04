#!/bin/bash
# ==============================================================================
# FEDORA DISTRIBUTION INSTALLER
# Deploys Copr repositories, native packages (DNF/DNF5), and Flatpaks
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log_info() { echo -e "${GREEN}[FEDORA INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[FEDORA WARN]${NC} $1"; }

DNF_CMD="dnf"
if command -v dnf5 &>/dev/null; then
    DNF_CMD="dnf5"
fi

log_info "Using package manager: $DNF_CMD"

# 1. RPM Fusion Repositories
log_info "Enabling RPM Fusion (Free & Non-Free)..."
FEDORA_VER=$(rpm -E %fedora)
sudo $DNF_CMD install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VER}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VER}.noarch.rpm" || true

# 2. Copr Repositories
log_info "Enabling required Copr repositories..."
if [ -f "$SCRIPT_DIR/copr-repos.txt" ]; then
    while IFS= read -r repo || [ -n "$repo" ]; do
        [[ "$repo" =~ ^#.*$ ]] && continue
        [[ -z "$repo" ]] && continue
        log_info "Enabling Copr repo: $repo"
        sudo $DNF_CMD copr enable -y "$repo" || log_warn "Failed to enable Copr repo $repo (skipping)"
    done < "$SCRIPT_DIR/copr-repos.txt"
fi

# 3. Native Package Installation
echo -e "\nChoose package installation scope:"
echo "1) Core Stack (Hyprland, Noctalia, Kitty, Neovim, Fastfetch, dev tools)"
echo "2) Complete Snapshot (All 500+ packages from Patata's live setup)"
read -rp "Selection [1-2, default: 1]: " PKG_MODE
PKG_MODE=${PKG_MODE:-1}

if [ "$PKG_MODE" == "2" ] && [ -f "$SCRIPT_DIR/dnf-all.txt" ]; then
    log_info "Installing all user packages from dnf-all.txt..."
    grep -v '^#' "$SCRIPT_DIR/dnf-all.txt" | grep -v '^$' | xargs sudo $DNF_CMD install -y --skip-unavailable || true
else
    log_info "Installing core packages from dnf-core.txt..."
    grep -v '^#' "$SCRIPT_DIR/dnf-core.txt" | grep -v '^$' | xargs sudo $DNF_CMD install -y --skip-unavailable || true
fi

# 4. Flatpak applications
if command -v flatpak &>/dev/null && [ -f "$SCRIPT_DIR/flatpak-all.txt" ]; then
    log_info "Ensuring Flathub remote is configured..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true

    log_info "Installing Flatpak applications..."
    while IFS= read -r app || [ -n "$app" ]; do
        [[ "$app" =~ ^#.*$ ]] && continue
        [[ -z "$app" ]] && continue
        flatpak install -y flathub "$app" || log_warn "Failed to install Flatpak $app (skipping)"
    done < "$SCRIPT_DIR/flatpak-all.txt"
fi

# 5. Goodix Fingerprint Support on Fedora
if lsusb | grep -qi "27c6:55b4"; then
    log_info "Goodix Fingerprint Sensor detected. Enabling fingerprint auth via authselect..."
    sudo $DNF_CMD install -y libfprint-goodixtls fprintd fprintd-pam || true
    sudo authselect enable-feature with-fingerprint || true
    sudo systemctl enable --now fprintd.service || true
fi

log_info "Fedora package installation complete!"
