{
  pkgs,
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
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Xbox controller
  hardware.xone.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Remove cookies
  systemd.timers."remove-cookies" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services."remove-cookies" = {
    script = ''
      rm /home/${username}/.local/share/qutebrowser/webengine/Cookies
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Steam
  jovian = {
    steam.enable = true;
    steam.user = username;
    hardware.has.amd.gpu = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    bibata-cursors
    firefox
    gnupg # pass
    heroic
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
