==================================================================
 DUMP DE CONFIGURACIÓN: kitty/.config/kitty
 Fecha: Sun Jan 11 10:13:31 PM -03 2026
==================================================================


################################################################################
AR-CHIVO: kitty/.config/kitty/kitty.conf
################################################################################

# --- Tus configuraciones personales (van PRIMERO) ---
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 6.0
window_padding_width 5
cursor_shape beam
background_opacity 0.85

# --- Cargar los colores de Pywal (van DESPUÉS) ---
# Esto define color0, color1, etc.
include ~/.cache/wal/colors-kitty.conf

background_opacity 0.85
# Mapea Ctrl+Backspace para que envíe la secuencia de Ctrl+W
map ctrl+backspace send_text all \x17

