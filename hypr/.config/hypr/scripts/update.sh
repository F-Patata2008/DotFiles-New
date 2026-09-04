#!/bin/bash
# ==============================================================================
# UNIVERSAL SYSTEM UPDATER (Arch Linux / Fedora / Flatpak)
# ==============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== 🚀 System Update Sequence Initialized ===${NC}"

if command -v dnf5 &>/dev/null; then
    echo -e "${YELLOW}[DNF5] Refreshing and upgrading packages...${NC}"
    sudo dnf5 upgrade --refresh -y
elif command -v dnf &>/dev/null; then
    echo -e "${YELLOW}[DNF] Refreshing and upgrading packages...${NC}"
    sudo dnf upgrade --refresh -y
elif command -v yay &>/dev/null; then
    echo -e "${YELLOW}[AUR / Pacman] Running full system upgrade via yay...${NC}"
    yay -Syu --noconfirm
elif command -v pacman &>/dev/null; then
    echo -e "${YELLOW}[Pacman] Running system upgrade...${NC}"
    sudo pacman -Syu --noconfirm
fi

if command -v flatpak &>/dev/null; then
    echo -e "${YELLOW}[Flatpak] Updating flatpak runtimes and apps...${NC}"
    flatpak update -y
fi

if command -v rustup &>/dev/null; then
    echo -e "${YELLOW}[Rust] Updating toolchains...${NC}"
    rustup update || true
fi

echo -e "${GREEN}=== ✔️ System Update Completed Successfully! ===${NC}"
