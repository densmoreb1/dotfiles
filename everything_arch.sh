#!/bin/bash

# Ran archinstall choosing hyprland

# Basic System
sudo pacman -S alacritty qutebrowser fish startship waybar stow 
sudo pacman -S brightnessctl tlp fprintd hyprpaper less man

# Utils
sudo pacman -S task neovim docker pass wl-clipboard qflipper

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd otf-font-awesome

# Start tlp
sudo systemctl enable tlp
sudo systemctl start tlp

# Start docker
sudo systemctl enable docker
sudo systemctl enable containerd
sudo systemctl start docker
sudo systemctl start containerd
sudo usermod -aG docker $USER
