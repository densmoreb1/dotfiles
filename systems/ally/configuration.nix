{
  pkgs,
  jovian,
  ...
}: let
  username = "brandon";
in {
  imports = [
    ./hardware-configuration.nix
    jovian.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

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
      PasswordAuthentication = true;
      AllowUsers = [username "root"];
      PermitRootLogin = "yes";
    };
  };

  jovian = {
    steam.enable = true;
    devices.steamdeck.enable = true;
    steam.autoStart = true;
    steam.user = username;
    steam.desktopSession = "plasma";
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    btop
    curl
    dust
    firefox
    fish
    git
    heroic
    mangohud
    mcpelauncher-client
    mcpelauncher-ui-qt
    ryzenadj
    sops
    starship
    tree
    unzip
    vim
    wget
    zip
  ];

  systemd.services.set-ryzenadj-tdp = {
    description = "Set Ryzen TDP via ryzenadj";
    wantedBy = ["multi-user.target"];
    after = ["network.target"]; # or "multi-user.target"
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000";
    };
  };

  system.stateVersion = "25.11";
}
