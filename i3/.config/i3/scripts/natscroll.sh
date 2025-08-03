#!/bin/bash
for id in $(xinput list | grep -i -E 'touchpad|mouse' | grep -o 'id=[0-9]*' | cut -d= -f2); do
  xinput set-prop $id "libinput Natural Scrolling Enabled" 1 2>/dev/null
done

