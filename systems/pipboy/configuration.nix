{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.download-buffer-size = 524288000;

  networking.hostName = "pipboy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/New_York";

  services.tlp.enable = true;
  services.openssh = {
    enable = true;
    ports = [6977];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["bdenzy"];
      PermitRootLogin = "no";
    };
  };

  users.users.bdenzy = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgjGHn32ltSLOtejcPrFpo/BIErzcyqyr0q4tUY2une brandon@archlinux"];
  };

  virtualisation.docker.enable = true;

  programs.fish.enable = true;
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

  system.stateVersion = "24.11";
}
