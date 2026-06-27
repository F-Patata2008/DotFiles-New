# AGENTS.md — Patata's Dotfiles

## Repo structure

Each top-level directory is a **GNU Stow package** mirroring `$HOME`:
```
stow --restow --verbose fastfetch hypr kitty nvim ohmyzsh zsh
```
- `Legacy/` is **not stowed** — it holds old Waybar/Rofi/Swaync configs replaced by Noctalia Shell
- `Install/` is **not stowed** — it's the deployment/backup toolbox
- `systemd` is listed in the install script but the directory does **not exist**
- `ohmyzsh/` and `nvim/.config/nvim/lua/Arduino-Nvim` are **git submodules**

## Deploying

- **Full install**: `Install/install-core.sh` — GPU profile + machine profile (Lenovo vs Generic), packages, system files, stow, services
- **Termux (Android)**: `Install/install-termux.sh` — stows only `fastfetch nvim ohmyzsh zsh`
- **Backup system files**: `Install/bakup.sh` — reverse-copies tracked `/etc` files back into `Install/system-files/`
- **Update package lists**: `Install/update_packages.sh` — regenerates `Install/pacman_packages.txt` / `aur_packages.txt` from the live system
- **Dump config to markdown**: `Install/dump.sh <dir>` — generates `**/DUMP_*.md` (gitignored)

## Package lists (two sets)

| Set | Used by | Path |
|-----|---------|------|
| Canonical | `install-core.sh` | `Install/pkgs/pacman-all.txt`, `aur-all.txt` |
| Stale | cron job | `Install/pacman_packages.txt`, `aur_packages.txt` (slightly different) |

## Hyprland quirks

- Config is **Lua** (`hyprland.lua` + `conf/*.lua`), not `.conf` files
- `.luarc.json` registers the global `hl` — required for Lua LSP
- Colors from Noctalia: `~/.cache/noctalia/hyprland-colors.lua`

## Neovim quirks

- `init.lua` with lazy.nvim; modular in `lua/` (core/, plugins/core/, plugins/extras/, custom/)
- **"Light mode"** disables heavy plugins (aider, copilot, arduino, debug, jupyter, latex) — detected via `TERMUX_VERSION` env var or `NVIM_PROFILE=light`

## Git workflow

- Single `main` branch. `push.sh` stages all (or specified) files, prompts for message, commits, and pushes to `origin main`
- Default commit message: `"Auto-commit: $timestamp"`

## Machine-specific notes

- **Lenovo E41-55** profile (`Install/profiles/Lenovo.sh`): TLP tuning, Goodix fingerprint (`libfprint-goodixtls-55x4` AUR), mkinitcpio with plymouth/lvm2/encrypt hooks, battery hibernation timer at 5%
- **fstab is NOT auto-copied** — UUIDs change between installs
- Supported GPU profiles: AMD, NVIDIA, Intel/VM
