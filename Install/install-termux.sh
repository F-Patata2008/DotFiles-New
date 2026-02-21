#!/bin/bash
# ==============================================================================
# TERMUX DOTFILES INSTALLATION SCRIPT
# For Samsung Galaxy Tab S10 FE
# ==============================================================================

echo "Starting Termux Setup..."

# 1. Request Storage Access
termux-setup-storage

# 2. Update and install core CLI tools
pkg update -y
pkg install -y zsh neovim git stow fastfetch eza bat fzf

# 3. Setup Zsh & Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Set Zsh as default shell in Termux
chsh -s zsh

# 4. Stow CLI configs (We skip Hyprland, SDDM, etc. because they don't work on Android)
cd ..
stow --restow --verbose fastfetch nvim ohmyzsh zsh

echo "✔️ Termux Setup Complete! Restart your terminal."
