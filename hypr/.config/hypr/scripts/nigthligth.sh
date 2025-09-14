#!/bin/bash

# This script toggles hyprsunset by checking its current state
# NOTE: This requires `jq` to be installed (sudo pacman -S jq)

CURRENT_STATE=$(hyprctl getoption misc:hyprsunset -j | jq -r '.str')

if [[ "$CURRENT_STATE" == "on" ]]; then
    hyprctl dispatch hyprsunset off
    notify-send "Night Light Disabled"
else
    hyprctl dispatch hyprsunset on
    notify-send "Night Light Enabled"
fi
