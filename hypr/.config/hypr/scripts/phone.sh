#!/bin/zsh

# Find the specific ID for the "Galaxy S8"
DEVICE_ID=$(kdeconnect-cli -a | grep "Galaxy S8" | awk -F': ' '{print $2}' | awk '{print $1}')

ICON="" # Nerd Font icon for phone

if [ -n "$DEVICE_ID" ]; then
    # Use qdbus and crucially, ignore the stderr error messages with 2>/dev/null
    BATTERY_LEVEL=$(qdbus6 org.kde.kdeconnect /modules/kdeconnect/devices/$DEVICE_ID/battery org.kde.kdeconnect.device.battery.charge 2>/dev/null)

    # Check if the command was successful and returned a number
    if [[ -n "$BATTERY_LEVEL" && "$BATTERY_LEVEL" -ge 0 ]]; then
        echo "{\"text\": \"$ICON $BATTERY_LEVEL%\", \"tooltip\": \"Phone Battery: $BATTERY_LEVEL%\"}"
    else
        # This will now correctly trigger if the command fails or phone is truly unreachable
        echo "{\"text\": \"$ICON --%\", \"tooltip\": \"Phone Disconnected\"}"
    fi
else
    # No device named "Galaxy S8" found
    echo "{\"text\": \"$ICON N/A\", \"tooltip\": \"Phone Not Found\"}"
fi
