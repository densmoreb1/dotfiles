#!/bin/bash

# Get connected monitors
monitors=$(xrandr | grep " connected" | awk '{ print $1 }')

# Check how many monitors are connected
count=$(echo "$monitors" | wc -l)

if [ "$count" -eq 1 ]; then
    # Single monitor setup
    i3-msg workspace 1; # Move to workspace 1
    i3-msg move workspace to output eDP-1
elif [ "$count" -ge 2 ]; then
    # Multiple monitor setup
    i3-msg workspace 1; # Move to workspace 1
    i3-msg move workspace to output eDP-1
    i3-msg workspace 2; # Move to workspace 2
    i3-msg move workspace to output DP-1-2-1
    i3-msg workspace 3; # Move to workspace 3
    i3-msg move workspace to output DP-1-2-2
fi
