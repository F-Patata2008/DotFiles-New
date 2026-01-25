#!/bin/bash

# --- CONFIG ---
# Check every 60 seconds
CHECK_INTERVAL=60

# Get the battery name (usually BAT0 or BAT1)
BAT=$(ls /sys/class/power_supply | grep '^BAT' | head -n 1)

# Variable to track the last notified level to prevent spam
last_notified=100

while true; do
    # Get current status and capacity
    status=$(cat /sys/class/power_supply/$BAT/status)
    capacity=$(cat /sys/class/power_supply/$BAT/capacity)

    # Only run checks if we are discharging
    if [ "$status" == "Discharging" ]; then
        
        # Level 30%
        if [ $capacity -le 30 ] && [ $capacity -gt 20 ] && [ $last_notified -gt 30 ]; then
            notify-send -u normal -i battery-level-30-symbolic "Battery Low" "Level: ${capacity}%"
            last_notified=30
        fi

        # Level 20%
        if [ $capacity -le 20 ] && [ $capacity -gt 15 ] && [ $last_notified -gt 20 ]; then
            notify-send -u normal -i battery-level-20-symbolic "Battery Low" "Level: ${capacity}%"
            last_notified=20
        fi

        # Level 15% (Getting serious)
        if [ $capacity -le 15 ] && [ $capacity -gt 10 ] && [ $last_notified -gt 15 ]; then
            notify-send -u critical -i battery-level-10-symbolic "Battery Critical" "Plug in charger! (${capacity}%)"
            last_notified=15
        fi

        # Level 10% (Red alert)
        if [ $capacity -le 10 ] && [ $capacity -gt 5 ] && [ $last_notified -gt 10 ]; then
            notify-send -u critical -i battery-level-10-symbolic "BATTERY DYING" "Save your work! (${capacity}%)"
            last_notified=10
        fi

        # Level 5% (Panic mode)
        if [ $capacity -le 5 ] && [ $last_notified -gt 5 ]; then
            notify-send -u critical -i battery-level-0-symbolic "SYSTEM IMMINENT SHUTDOWN" "Bye bye... (${capacity}%)"
            last_notified=5
        fi

    else
        # If charging, reset the notification tracker
        # We set it to 100 so when you unplug, it's ready to notify down again
        if [ "$status" != "Discharging" ]; then
            last_notified=100
        fi
    fi

    sleep $CHECK_INTERVAL
done
