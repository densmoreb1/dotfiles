{
  pkgs,
  jovian,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    jovian.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "ally";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.download-buffer-size = 524288000;

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  jovian = {
    steam.enable = true;
    devices.steamdeck.enable = true;
    steam.autoStart = true;
    steam.user = "brandon";
    steam.desktopSession = "plasma";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brandon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgjGHn32ltSLOtejcPrFpo/BIErzcyqyr0q4tUY2une brandon@archlinux"];
  };

  # packages
  environment.systemPackages = with pkgs; [
    btop
    curl
    dust
    fish
    git
    heroic
    mangohud
    sops
    starship
    tree
    unzip
    vim
    wget
    zip
  ];

  # List services that you want to enable:
  # fish
  programs.fish.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [6977];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["brandon"];
      PermitRootLogin = "no";
    };
  };

  networking.firewall.enable = false;
  system.stateVersion = "25.11";
}
