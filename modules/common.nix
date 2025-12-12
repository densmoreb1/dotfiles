{
  pkgs,
  username,
  ...
}: {
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nix settings
  nix.settings.download-buffer-size = 524288000;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["brandon"];

  # Hardware updates
  services.fwupd.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time Zone
  time.timeZone = "America/New_York";

  # Firewall
  networking.firewall.enable = false;

  # Power saving
  services.tlp.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    ports = [6977];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [username];
      PermitRootLogin = "no";
    };
  };

  # Users
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker" "dialout"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgjGHn32ltSLOtejcPrFpo/BIErzcyqyr0q4tUY2une brandon@archlinux"];
  };

  # Shell
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    btop
    cryptsetup
    curl
    dust
    fish
    git
    sops
    starship
    tree
    unzip
    vim
    wget
    zip
  ];
}
