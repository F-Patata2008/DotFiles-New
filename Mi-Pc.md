# Arch Setup
Hello, I use Arch (BTW), with Hyprland and SDDM, no full DE, as I find it more cumbersome.

I do prefer Gnome's Aesthetic, but i do like KDE better customization and integration.

I mostly use Hyprland for my day to day tasks, as it better suits my own workflow

## My machine spec are as following:
- **Model:** Lenovo E41-55
- **RAM:** 2 x 8 DDR4 3200 SODDIM Memory + 24 GB Swap
- **Processor:** Ryzen 3 3250U 2 Cores 4 Threads
- **GPU:** Vega 3 Integrated Graphics
- **SSD:** 500 GB M2 NVME Gen 3 WD Black
- **Screen:** 1366x768 14", 60 Hz
- **Fingerprint Reader:** 27c6:55b4 Shenzhen Goodix Technology Co.,Ltd. Fingerprint Reader

### My partition scheme
NAME                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1               259:0    0 465.8G  0 disk
├─nvme0n1p1           259:1    0     1G  0 part /boot
└─nvme0n1p2           259:2    0 464.8G  0 part
  ├─ssdm2-swap        254:0    0    24G  0 lvm  [SWAP]
  ├─ssdm2-arch--root  254:1    0  48.8G  0 lvm  /
  ├─ssdm2-linux--home 254:2    0   344G  0 lvm  /home
  └─ssdm2-zorin       254:3    0    48G  0 lvm

## Current System Setup
I do have my Hyprland setup for my own workflow, wich includes the following:

- **Mobile integration:** I use KDE Connect, but have some issues, wich include:
    - Can not answer rcs chats
    - Can not mount my phone's filesystem in Nautilus, having to use dolphin
    - Use a custom Script for checking my phone's battery, but it does not allow me to monitor if its charging or not

- **Dotfiles + Stow:** My config makes use of the stow functionality, so I have everything all in one place, wich is my ~/Dotfiles/ folder, wich is also a public Github repository

- **Batery and suspension optimizations:** Another part of my configuration, is the ability to hibernate and suspend to RAM, wich allows me to, after 15 minutes of idling, at least in my Hyprland session, suspend to RAM my pc, and shutdown to preserve Battery

- **Plymouth and Grub Themes:** A big part of my customization are the Grub and Plymouth Themes, wich correspond to Minecarft 1.16 and Minecraft world loading screen respectively.

- **I use the Hypr suite of addons:** My config makes use of the Hypr suite, plus some addons, wich includes
    - HyprSunset
    - HyprIdle
    - HyprLock
    - HyprPaper
    - HyprShot
    - HyprColorPicker
    - Waybar
    - Kitty
    - Wal
    - Opera (I do want to migrate to Zen Browser, as Opera consumes to much resources)
    - Neovim
    - Rofi
    - Rofi-moji
    - Clipse
    - SwayOSD
    - SwayNC
    - Some Gnome Apps
        - Nautilus
        - Document Scanner
        - Calenda
        - Among others

- **Gnome:** Only a selection of a few apps wich are indispensable for my workflow

- **LVM:** My setup makes use of LVM for better partition sizing and mounting, plus better rezing and less hassle with ssd blocks


### My Dotfiles Structure
.
├── eww
├── fastfetch
├── GitHub-Recovery
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
50 directories



## My dotfiles repo:
https://github.com/F-Patata2008/DotFiles-New
