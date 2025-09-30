#!/bin/zsh

echo "Upadting"
sudo reflector --country 'Chile,Argentina,Brazil,Peru' --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syuu --noconfirm --sudoloop
yay -Syuu --noconfirm --sudoloop
