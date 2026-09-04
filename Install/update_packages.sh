#!/bin/bash
# ==============================================================================
# DISTRO-AWARE PACKAGE LIST SYNCHRONIZER
# Automatically exports installed packages for the current distro
# ==============================================================================

set -e; set -u; set -o pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log_info() { echo -e "${GREEN}[UPDATE-PKGS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[UPDATE-PKGS]${NC} $1"; }

if [ -f /etc/fedora-release ]; then
    log_info "Detected Fedora Linux. Synchronizing Fedora package manifests..."
    FEDORA_DIR="$SCRIPT_DIR/profiles/distros/fedora"
    mkdir -p "$FEDORA_DIR"

    # 1. DNF user-installed packages
    DNF_CMD="dnf"
    command -v dnf5 &>/dev/null && DNF_CMD="dnf5"
    log_info "Exporting user-installed packages via $DNF_CMD..."
    $DNF_CMD repoquery --userinstalled --qf "%{name}\n" | sort -u > "$FEDORA_DIR/dnf-all.txt.tmp"
    mv "$FEDORA_DIR/dnf-all.txt.tmp" "$FEDORA_DIR/dnf-all.txt"

    # 2. Copr repos
    log_info "Exporting enabled Copr repositories..."
    dnf repolist | grep -o 'copr:copr.fedorainfracloud.org:[^ ]*' | sed 's/copr:copr.fedorainfracloud.org://' | sort -u > "$FEDORA_DIR/copr-repos.txt.tmp"
    mv "$FEDORA_DIR/copr-repos.txt.tmp" "$FEDORA_DIR/copr-repos.txt"

    # 3. Flatpaks
    if command -v flatpak &>/dev/null; then
        log_info "Exporting Flatpak applications..."
        flatpak list --app --columns=application 2>/dev/null | tail -n +2 | sort -u > "$FEDORA_DIR/flatpak-all.txt.tmp"
        mv "$FEDORA_DIR/flatpak-all.txt.tmp" "$FEDORA_DIR/flatpak-all.txt"
    fi

    log_info "Fedora package lists updated successfully!"

elif [ -f /etc/arch-release ]; then
    log_info "Detected Arch Linux. Synchronizing Arch package manifests..."
    ARCH_DIR="$SCRIPT_DIR/profiles/distros/arch"
    mkdir -p "$ARCH_DIR"

    # 1. Official Pacman packages
    pacman -Qenq | sort -u > "$ARCH_DIR/pacman-all.txt.tmp"
    mv "$ARCH_DIR/pacman-all.txt.tmp" "$ARCH_DIR/pacman-all.txt"
    cp "$ARCH_DIR/pacman-all.txt" "$SCRIPT_DIR/pacman_packages.txt" 2>/dev/null || true

    # 2. AUR packages
    pacman -Qemq | sort -u > "$ARCH_DIR/aur-all.txt.tmp"
    mv "$ARCH_DIR/aur-all.txt.tmp" "$ARCH_DIR/aur-all.txt"
    cp "$ARCH_DIR/aur-all.txt" "$SCRIPT_DIR/aur_packages.txt" 2>/dev/null || true

    log_info "Arch Linux package lists updated successfully!"
else
    log_warn "Unsupported distribution for automated package dump."
    exit 1
fi
