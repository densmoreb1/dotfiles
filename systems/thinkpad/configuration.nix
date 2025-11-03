{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Download size
  nix.settings.download-buffer-size = 524288000;

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  # Host Name
  networking.hostName = "thinkpad";

  # Use Network Manager
  networking.networkmanager.enable = true;

  # Set Time Zone
  time.timeZone = "America/New_York";

  # Desktop
  programs.hyprland.enable = true;
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  # Enable TLP
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 79;
      STOP_CHARGE_THRESH_BAT0 = 100;
    };
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Define users
  users.users.brandon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker" "dialout"];
    shell = pkgs.fish;
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    bibata-cursors
    brightnessctl
    btop
    curl
    docker
    dust
    firefox
    fish
    git
    gnupg # pass
    hyprpaper
    openvpn
    pass # passwords
    pinentry-qt # pass
    python313
    qflipper
    qutebrowser
    sops
    stow
    tree
    unzip
    vim
    waybar
    wget
    wirelesstools
    wl-clipboard
    wofi # app launcher
    wofi-pass # pass
    xfce.thunar
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  system.stateVersion = "24.11";
}
