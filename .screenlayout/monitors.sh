#!/bin/sh
xrandr --output eDP-1 --primary --output DP-1-0.1 --auto --right-of eDP-1 --output DP-1-0.2 --auto --right-of DP-1-0.1
xrandr --output eDP-1 --primary --output DP-1-1.1 --auto --right-of eDP-1 --output DP-1-1.2 --auto --right-of DP-1-1.1
setxkbmap -option caps:escape
