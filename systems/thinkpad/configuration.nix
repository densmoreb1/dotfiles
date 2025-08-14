{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Flipper Zero
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0666", GROUP="dialout"
  '';

  # Define your hostname.
  networking.hostName = "thinkpad";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Desktop
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  programs.hyprland.enable = true;

  services.displayManager.defaultSession = "hyprland";
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "brandon";

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 79;
      STOP_CHARGE_THRESH_BAT0 = 100;
    };
  };

  # enable docker
  virtualisation.docker.enable = true;

  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker" "dialout"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    bibata-cursors
    brightnessctl
    btop
    cargo # neovim
    curl
    docker
    dust
    fish
    gcc # neovim
    git
    gnupg # pass
    hyprpaper
    neovim
    nodejs # neovim
    openvpn
    pass # passwords
    pinentry-qt # pass
    python313
    playwright.browsers
    qutebrowser
    ripgrep # neovim
    rustc # neovim
    starship
    stow
    taskwarrior3
    tree
    twingate
    unzip
    qflipper
    vim
    wirelesstools
    wget
    wl-clipboard
    waybar
    wofi # app launcher
    wofi-pass # pass
    xfce.thunar
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  system.stateVersion = "24.11";
}
