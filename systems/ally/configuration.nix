{
  pkgs,
  jovian,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    jovian.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.download-buffer-size = 524288000;

  networking.hostName = "ally";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "America/New_York";

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.brandon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgjGHn32ltSLOtejcPrFpo/BIErzcyqyr0q4tUY2une brandon@archlinux"];
  };

  services.openssh = {
    enable = true;
    ports = [6977];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["brandon"];
      PermitRootLogin = "no";
    };
  };

  jovian = {
    steam.enable = true;
    devices.steamdeck.enable = true;
    steam.autoStart = true;
    steam.user = "brandon";
    steam.desktopSession = "plasma";
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
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

  system.stateVersion = "25.11";
}
