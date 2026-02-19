==================================================================
 DUMP DE CONFIGURACIÓN: fastfetch/.config/fastfetch
 Fecha: Thu Feb 19 12:30:24 AM -03 2026
==================================================================


################################################################################
ARCHIVO: fastfetch/.config/fastfetch/config.jsonc
################################################################################

{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "kitty-direct",
    "source": "~/Dotfiles/fastfetch/.config/fastfetch/Miku.png",
    "type": "kitty",
    "width": 60,
    //"height": 20,
    "padding": {
      "top": 1,
      "left": 2,
      "right": 4
    }
  },
  "display": {
    "separator": " ➜  ",
    "color": "white"
  },
  "modules": [
    // ---------------- HARDWARE (Red Borders & Keys) ----------------
    {
      "type": "custom",
      "format": "┌────────────────────── Hardware ──────────────────────┐",
      "outputColor": "red"
    },
    {
      "type": "title",
      "key": "│  PC",
      "keyColor": "red"
    },
    {
      "type": "host",
      "key": "│ ├ 󰌢 Host",
      "keyColor": "red"
    },
    {
      "type": "board",
      "key": "│ ├ 󰘚 Mobo",
      "keyColor": "red"
    },
    {
      "type": "chassis",
      "key": "│ ├ 󰆧 Case",
      "keyColor": "red"
    },
    {
      "type": "cpu",
      "key": "│ ├ 󰍛 CPU",
      "keyColor": "red"
    },
    {
      "type": "gpu",
      "key": "│ ├ 󰍛 GPU",
      "keyColor": "red"
    },
    {
      "type": "memory",
      "key": "│ ├ 󰑭 RAM",
      "keyColor": "red"
    },
    {
      "type": "physicalmemory",
      "key": "│ ├ 󰑭 Phys",
      "keyColor": "red"
    },
    {
      "type": "swap",
      "key": "│ ├ 󰓡 Swap",
      "keyColor": "red"
    },
    {
      "type": "disk",
      "key": "│ ├ 󰋊 Disk",
      "keyColor": "red"
    },
    {
      "type": "physicaldisk",
      "key": "│ ├ 󰋊 Phys",
      "keyColor": "red"
    },
    {
      "type": "battery",
      "key": "│ └  Batt",
      "keyColor": "red",
      "format": "{capacity}% [{status}] [{time-formatted}]"
    },
    {
      "type": "custom",
      "format": "└──────────────────────────────────────────────────────┘",
      "outputColor": "red"
    },
    "break",

    // ---------------- SOFTWARE (Yellow Borders & Keys) ----------------
    {
      "type": "custom",
      "format": "┌────────────────────── Software ──────────────────────┐",
      "outputColor": "yellow"
    },
    {
      "type": "os",
      "key": "│  OS",
      "keyColor": "yellow"
    },
    {
      "type": "kernel",
      "key": "│ ├  Kern",
      "keyColor": "yellow"
    },
    {
      "type": "bootmgr",
      "key": "│ ├  Boot",
      "keyColor": "yellow"
    },
    {
      "type": "packages",
      "key": "│ ├ 󰏖 Pkgs",
      "keyColor": "yellow"
    },
    {
      "type": "shell",
      "key": "│ ├  Shll",
      "keyColor": "yellow"
    },
    {
      "type": "uptime",
      "key": "│ └ 󰅐 Time",
      "keyColor": "yellow"
    },
    {
      "type": "custom",
      "format": "└──────────────────────────────────────────────────────┘",
      "outputColor": "yellow"
    },
    "break",

    // ---------------- ENVIRONMENT (Blue Borders & Keys) ----------------
    {
      "type": "custom",
      "format": "┌──────────────────── Environment ─────────────────────┐",
      "outputColor": "blue"
    },
    // Using WM as root because Hyprland is a WM
    {
      "type": "wm",
      "key": "│  WM",
      "keyColor": "blue"
    },
    {
      "type": "display",
      "key": "│ ├ 󰍹 Disp",
      "keyColor": "blue"
    },
    {
      "type": "wmtheme",
      "key": "│ ├ 󰉼 WThm",
      "keyColor": "blue"
    },
    {
      "type": "theme",
      "key": "│ ├ 󰉼 Thme",
      "keyColor": "blue"
    },
    {
      "type": "icons",
      "key": "│ ├ 󰀻 Icon",
      "keyColor": "blue"
    },
    {
      "type": "font",
      "key": "│ ├  Font",
      "keyColor": "blue"
    },
    {
      "type": "cursor",
      "key": "│ ├  Curs",
      "keyColor": "blue"
    },
    {
      "type": "terminal",
      "key": "│ ├  Term",
      "keyColor": "blue"
    },
    {
      "type": "terminalfont",
      "key": "│ └  TFnt",
      "keyColor": "blue"
    },
    {
      "type": "custom",
      "format": "└──────────────────────────────────────────────────────┘",
      "outputColor": "blue"
    },
    "break",

    // ---------------- CONNECTIVITY (Cyan Borders & Keys) ----------------
    {
      "type": "custom",
      "format": "┌──────────────────── Connectivity ────────────────────┐",
      "outputColor": "cyan"
    },
    {
      "type": "custom",
      "key": "│ Quote",
      "keyColor": "magenta",
      "format": "\u001b[35m-< Blame this on the misfortune of your birth >-"
    },
    {
      "type": "localip",
      "key": "│ ├ 󰩟 IP",
      "keyColor": "cyan"
    },
    {
      "type": "wifi",
      "key": "│ ├  Wifi",
      "keyColor": "cyan"
    },
    {
      "type": "sound",
      "key": "│ ├ 󰓃 Vol",
      "keyColor": "cyan"
    },
    {
      "type": "bluetooth",
      "key": "│ ├  Blue",
      "keyColor": "cyan"
    },
    {
      "type": "camera",
      "key": "│ ├ 󰄀 Cam",
      "keyColor": "cyan"
    },
    {
      "type": "locale",
      "key": "│ ├  Lang",
      "keyColor": "cyan"
    },
    {
      "type": "weather",
      "key": "│ └ 󰖐 Wthr",
      "keyColor": "cyan"
    },
    {
      "type": "custom",
      "format": "└──────────────────────────────────────────────────────┘",
      "outputColor": "cyan"
    },
    "break",
    {
        "type": "colors",
        "paddingLeft": 20,
        "symbol": "circle"
    }
  ]
}
