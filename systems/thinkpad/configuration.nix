{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Flipper Zero
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0666", GROUP="dialout"
  '';

  # Finger print scanner
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.pam.services.login.fprintAuth = true;

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

  # Host Name
  networking.hostName = "thinkpad";

  # Desktop
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Hardware updates
  services.fwupd.enable = true;

  # Enable TLP
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 79;
      STOP_CHARGE_THRESH_BAT0 = 100;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_BOOST_ON_AC = 1;
    };
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # SSH for build
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["brandon"];
      PermitRootLogin = "no";
    };
  };

  stylix = {
    enable = true;
    image = ../../wallpapers/2-Pawel-Czerwinski-Abstract-Purple-Blue.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    opacity = {
      terminal = 0.8;
      applications = 0.8;
    };
    fonts = {
      sizes.terminal = 13;
      serif.package = pkgs.nerd-fonts.jetbrains-mono;
      sansSerif.package = pkgs.nerd-fonts.jetbrains-mono;
      monospace.package = pkgs.nerd-fonts.jetbrains-mono;
      emoji.package = pkgs.noto-fonts-color-emoji;
    };
  };

  # Define users
  users.users.brandon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker" "dialout"];
    shell = pkgs.fish;
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bibata-cursors
    brightnessctl
    docker
    firefox
    gnupg # pass
    hyprpaper
    localsend
    openvpn
    pass # passwords
    pinentry-qt # pass
    python313
    qFlipper
    qutebrowser
    waybar
    wirelesstools
    wl-clipboard
    wofi # app launcher
    wofi-pass # pass
    xfce.thunar
  ];

  system.stateVersion = "24.11";
}
