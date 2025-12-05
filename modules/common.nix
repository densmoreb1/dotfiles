{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.download-buffer-size = 524288000;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  programs.fish.enable = true;
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
