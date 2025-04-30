# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
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

  # Define your hostname.
  networking.hostName = "nixos";

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # links /libexec from derivations to /run/current-system/sw
  environment.pathsToLink = ["/libexec"];

  # Enable the X11 windowing system.
  services.displayManager.defaultSession = "none+i3";
  services.xserver.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu #application launcher most people use
      i3status # gives you the default i3 status bar
      i3lock #default i3 screen locker
      i3blocks #if you are planning on using i3blocks over i3status
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:escape";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    alacritty
    brightnessctl
    btop
    curl
    docker
    dust
    firefox
    fish
    git
    gnupg
    lm_sensors
    neovim
    nodejs
    pass
    picom
    pinentry-qt
    preload
    python313
    qutebrowser
    starship
    stow
    taskwarrior3
    tree
    unclutter
    unzip
    vim
    wirelesstools
    wget
    xfce.thunar
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # List services that you want to enable:
  # programs
  programs.nm-applet.enable = true;
  programs.fish.enable = true;

  # enable docker
  virtualisation.docker.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
