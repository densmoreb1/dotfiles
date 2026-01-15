{
  pkgs,
  lib,
  jovian,
  username,
  ...
}: {
  imports = [
    jovian.nixosModules.default
  ];

  networking.hostName = "rose";

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };

  # Xbox controller
  hardware.xone.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  jovian = {
    steam.enable = true;
    steam.user = username;
    steam.desktopSession = "hyprland";
    hardware.has.amd.gpu = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    bibata-cursors
    firefox
    gnupg # pass
    hyprpaper
    localsend
    mangohud
    pass # passwords
    pinentry-qt # pass
    python313
    qFlipper
    qutebrowser
    thunar
    waybar
    wirelesstools
    wl-clipboard
    wofi # app launcher
    wofi-pass # pass
  ];

  system.stateVersion = "25.11";
}
