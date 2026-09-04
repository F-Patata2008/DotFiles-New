# Arch SN750 Custom Boot Profile

This directory encapsulates the dedicated bootloader and storage configuration for Comrade Patata's **500GB WD Black SN750 NVMe SSD** running Arch Linux.

## Topology & Specifications

- **Hardware**: Lenovo E41-55 (Ryzen 3 3250U, Vega 3, 16GB RAM)
- **Disk**: Western Digital Black SN750 NVMe 500GB
- **Encryption**: LUKS Container (`UUID=92b2c58d-7df7-4e26-99cf-57247bc82a51:cryptlvm`)
- **LVM Virtual Partitions**:
  - `/dev/Patata/root` (Mounted at `/`)
  - `/dev/Patata/home` (Mounted at `/home`)
  - `/dev/Patata/swap` (Swap space & hibernate resume target)
- **Bootloader**: GRUB with `minegrub` theme
- **Splash Screen**: Plymouth with `mc` (Minecraft) theme
- **Initramfs**: `mkinitcpio` with hooks:
  `base udev plymouth autodetect microcode modconf keyboard keymap consolefont block encrypt lvm2 filesystems resume fsck`

## Usage

This configuration is isolated from generic installs to prevent bricking non-Arch or non-encrypted partitions.

To deploy safely onto the Arch SN750 installation:
```bash
cd Install/profiles/machines/arch-sn750-custom-boot
./setup-boot.sh
```
