#!/bin/bash

# Ran archinstall choosing hyprland
# intel-graphics

# Basic System
sudo pacman -S alacritty qutebrowser fish startship waybar stow 
sudo pacman -S brightnessctl tlp fprintd hyprpaper less man

# Utils
sudo pacman -S task neovim docker docker-compose pass wl-clipboard qflipper acpi_call

# Neovim
sudo pacman -S unzip ripgrep npm

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

# Graphics
# followed https://wiki.archlinux.org/title/Hybrid_graphics#Using_udev_rules
# and https://wiki.archlinux.org/title/Hybrid_graphics#Using_acpi_call

# SDDM Themes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"

# Wofi Themes
git clone https://github.com/joao-vitor-sr/wofi-themes-collection ~/.local/share/wofi-themes-collection/
