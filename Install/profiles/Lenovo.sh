#!/bin/bash
# ==============================================================================
# MACHINE PROFILE: Lenovo E41-55
# Applies aggressive TLP battery saving, Fingerprint reader, and custom mkinitcpio
# ==============================================================================
set -e; set -u

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}>>> Applying Lenovo E41-55 Hardware Profile...${NC}"

# 1. Copy Lenovo-specific system files
# CRITICAL: We DO NOT copy fstab blindly, because UUIDs change on reinstall!
echo -e "${GREEN}[INFO]${NC} Copying TLP, udev, and mkinitcpio rules..."
sudo cp ../system-files/machines/lenovo/mkinitcpio.conf /etc/mkinitcpio.conf
sudo cp ../system-files/machines/lenovo/tlp.conf /etc/tlp.conf
sudo cp -r ../system-files/machines/lenovo/udev /etc/

echo -e "${YELLOW}[WARN]${NC} /etc/fstab is available in system-files/machines/lenovo/fstab for reference, but was NOT copied automatically to prevent unbootable systems."

# 2. Setup Fingerprint
FINGERPRINT_ID="27c6:55b4"
if lsusb | grep -q "$FINGERPRINT_ID"; then
    echo -e "${GREEN}[INFO]${NC} Goodix Fingerprint Reader found. Installing driver..."
    yay -S --needed --noconfirm libfprint-goodixtls-55x4
    
    # Patch PAM
    FP_LINE="auth      sufficient      pam_fprintd.so"
    for pam_file in sudo sddm; do
        if ! grep -q "pam_fprintd.so" "/etc/pam.d/$pam_file"; then
            sudo sed -i "1s,^,$FP_LINE\n," "/etc/pam.d/$pam_file"
        fi
    done
    sudo systemctl enable fprintd.service
fi

# 3. Enable Battery Services
sudo systemctl enable tlp.service check-bat.timer

# 4. Rebuild initramfs with new hooks
echo -e "${GREEN}[INFO]${NC} Rebuilding mkinitcpio for Lenovo..."
sudo mkinitcpio -P

echo -e "${GREEN}✔️ Lenovo E41-55 profile applied successfully.${NC}"
