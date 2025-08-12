#!/bin/bash

# Ran archinstall choosing hyprland

# Basic System
sudo pacman -S alacritty qutebrowser fish startship waybar stow brightnessctl 

# Utils
sudo pacman -S task neovim docker

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd otf-font-awesome

# Start docker
sudo systemctl enable docker
sudo systemctl enable containerd
sudo systemctl start docker
sudo systemctl start containerd
sudo usermod -aG docker $USER
