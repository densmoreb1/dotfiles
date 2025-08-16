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

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bdenzy = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    cryptsetup
    btop
    docker
    dust
    fish
    git
    tree
    starship
    unzip
    vim
    wget
    zip
  ];

  # List services that you want to enable:
  # fish
  programs.fish.enable = true;

  # tlp
  services.tlp.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.ports = [6977];

  networking.firewall.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}
