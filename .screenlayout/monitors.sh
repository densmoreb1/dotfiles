#!/bin/sh
xrandr --auto
xrandr --output eDP-1 --auto \
       --output DP-1-2-1 --mode 1920x1080 --rate 60 --right-of eDP-1 \
       --output DP-1-2-2 --mode 1920x1080 --rate 60 --right-of DP-1-2-1

