#!/bin/zsh

# Detect power
if [[ $(cat /sys/class/power_supply/AC/online) == 1 ]]; then
    POWER_STATUS="AC"
else
    POWER_STATUS="BAT"
fi

# Define modes: mode -> timeout + action
declare -A MODES_TIMEOUT=(
    ["IN"]=900
    ["Patata Xtra"]=1200
    ["Patata Ultra"]=1800
    ["Patata"] = 900
    ["Nunca"]=0
)

declare -A MODES_ACTION=(
    ["IN"]="suspend-then-hibernate"
    ["Patata"]="suspend"
    ["Nunca"]="nop"
)

# Present only appropriate modes
if [[ $POWER_STATUS == "AC" ]]; then
    OPTIONS=("Patata" "Patata Xtra" "Patata Ultra" "Nunca")
else
    OPTIONS=("In" "Patata" "Patata Xtra" "Nunca")
fi

MODE=$(printf "%s\n" "${OPTIONS[@]}" | rofi -dmenu -p "Select Mode")

TIMEOUT=${MODES_TIMEOUT[$MODE]}
ACTION=${MODES_ACTION[$MODE]}

HYPRIDLE_CONF="$HOME/.config/hypr/hypridle.conf"

cat > "$HYPRIDLE_CONF" <<EOF

pat = $((TIMEOUT /3))

general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = pidof hyprlock || hyprlock
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = $pat
    on-timeout = brightnessctl -s set 10%
    on-resume = brightnessctl -r
}

listener {
    timeout = $((pat * 2))
    on-timeout = pidof hyprlock || hyprlock
}

listener {
    timeout = $TIMEOUT
EOF

if [[ "$ACTION" == "nop" ]]; then
    echo "    on-timeout = true" >> "$HYPRIDLE_CONF"
else
    echo "    on-timeout = systemctl $ACTION" >> "$HYPRIDLE_CONF"
fi

cat >> "$HYPRIDLE_CONF" <<EOF
    on-resume = hyprctl dispatch dpms on
}
EOF

pkill hypridle
hypridle &
