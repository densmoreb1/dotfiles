{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "pipboy";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.download-buffer-size = 524288000;

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bdenzy = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgjGHn32ltSLOtejcPrFpo/BIErzcyqyr0q4tUY2une brandon@archlinux"];
  };

  # packages
  environment.systemPackages = with pkgs; [
    curl
    cryptsetup
    btop
    docker
    dust
    fish
    git
    tree
    sops
    starship
    unzip
    vim
    wget
    zip
  ];

  # List services that you want to enable:
  # fish
  programs.fish.enable = true;

  # TLP
  services.tlp.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [6977];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["bdenzy"]; # Allows all users by default. Can be [ "user1" "user2" ]
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  networking.firewall.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}
