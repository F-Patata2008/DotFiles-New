# 🏛️ Legacy Rice Configurations

This directory preserves the classic Wayland rice components previously used on this workstation. These standalone modular utilities were unified and superseded by **Noctalia Shell** (which consolidates the status bar, launcher, control center dashboard, notifications, and on-screen displays).

> [!NOTE]
> This folder is **not stowed** by default. It is maintained here for historical reference, modular reuse, and fallback experimentation.

---

## 🗂️ Component Archive

| Directory | Original Role | Replaced By in Active Rice |
| :--- | :--- | :--- |
| [`hypr/`](hypr/) | Classic Hyprland helper configs (hyprpaper, hypridle, hyprlock) | Noctalia Shell + modern Hyprland Lua stack |
| [`waybar/`](waybar/) | Modular Waybar status bar and custom CSS widgets | Noctalia dynamic Bar |
| [`rofi/`](rofi/) | Rofi Wayland application launcher & window switcher | Noctalia App Launcher (`fuzzel` fallback) |
| [`rofimoji/`](rofimoji/) | Rofi emoji / symbol picker | Noctalia Launcher plugin system |
| [`swaync/`](swaync/) | SwayNotificationCenter notification tray & widget panel | Noctalia Control Center & Notification Center |
| [`swayosd/`](swayosd/) | SwayOSD volume, brightness, and caps-lock overlays | Noctalia On-Screen Displays (OSDs) |
| [`swaylock/`](swaylock/) | Swaylock effects lockscreen | Noctalia Lockscreen / Hyprlock |
| [`wlogout/`](wlogout/) | Wlogout Wayland power menu | Noctalia Session / Power menu |

---

## 💡 How to Reuse
If you ever want to revive or test any of these standalone components:
```bash
# Example: Deploying the classic Waybar configuration manually
mkdir -p ~/.config/waybar
cp -r ~/Dotfiles/Legacy/waybar/* ~/.config/waybar/
waybar &
```
