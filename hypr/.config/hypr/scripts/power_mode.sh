#!/bin/zsh
|
mode=$(cat ~/.config/hypr/scripts/power_mode.txt 2>/dev/null)
case "$mode" in
  "Nunca") icon="󰪚"; class="pmode-never"; color="#e74c3c"; tooltip="Suspensión desactivada" ;;
  "Patata Ultra") icon="󰓇"; class="pmode-ultra"; color="#f1c40f"; tooltip="Super carga (1800s)" ;;
  "Patata Xtra") icon="󰔡"; class="pmode-xtra"; color="#2ecc71"; tooltip="Carga extra (1200s)" ;;
  "Patata") icon="󰛶"; class="pmode-normal"; color="#3498db"; tooltip="Normal (900s)" ;;
  "IN") icon="󰤪"; class="pmode-school"; color="#8e44ad"; tooltip="Modo escuela (900s)" ;;
  *) icon="󰐧"; class="pmode-unk"; color="#95a5a6"; tooltip="Sin modo seleccionado" ;;
esac
echo "{\"text\": \"$icon\", \"tooltip\": \"$mode: $tooltip\", \"class\": \"$class\"}"
