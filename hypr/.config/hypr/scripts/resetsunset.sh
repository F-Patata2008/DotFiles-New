#!/bin/bash
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t /run/user/$(id -u)/hypr/ | head -n 1)
killall hyprsunset
sleep 0.1
hyprsunset &
