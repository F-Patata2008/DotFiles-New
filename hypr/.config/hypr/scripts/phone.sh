#!/bin/zsh

# Find the first connected device ID
DEVICE_ID=$(kdeconnect-cli -l --id-only)

if [ -n "$DEVICE_ID" ]; then
    # Get the battery percentage for the device
    BATTERY_LEVEL=$(kdeconnect-cli -d "$DEVICE_ID" --battery-charge)
    ICON="  " # Nerd Font icon for phone

    if [ -n "$BATTERY_LEVEL" ]; then
        echo "{\"text\": \"$ICON $BATTERY_LEVEL\", \"tooltip\": \"Phone Battery\"}"
    else
        # Handles case where device is paired but not connected
        echo "{\"text\": \"$ICON --%\", \"tooltip\": \"Phone Disconnected\"}"
    fi
else
    # No devices paired/found
    echo "{\"text\": \"$ICON N/A\", \"tooltip\": \"No Phone Paired\"}"
fi
