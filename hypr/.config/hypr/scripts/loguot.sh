#!/usr/bin/env bash

#// Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

#// Set file variables
confDir="$HOME/.config"
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

#// Detect monitor resolution
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

#// Scale config layout and style
wlColms=6
export mgn=$((y_mon * 28 / hypr_scale))
export hvr=$((y_mon * 23 / hypr_scale))

#// Scale font size
export fntSize=$((y_mon * 2 / 100))

#// Detect wallpaper brightness
export BtnCol="white"

#// Eval hypr border radius
hypr_border="${hypr_border:-10}"
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

#// Eval config files
wlStyle="$(envsubst <"${wlTmplt}")"

#// Launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
