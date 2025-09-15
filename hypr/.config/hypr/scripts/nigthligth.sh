#!/bin/bash

# This is the compatible version that works on all Hyprland versions

if pgrep -x "hyprsunset" > /dev/null
then
    # If hyprsunset is running, kill it and notify
    killall hyprsunset
    notify-send "Night Light Disabled" -h string:x-canonical-private-synchronous:nightlight-toggle
else
    # If hyprsunset is not running, start it and notify
    hyprsunset &
    notify-send "Night Light Enabled" -h string:x-canonical-private-synchronous:nightlight-toggle
fi
