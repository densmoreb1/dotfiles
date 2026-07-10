{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/mail.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/default.nix
    ../../modules/system/style.nix
  ];

  networking.hostName = "rose";

  # Xbox controller
  hardware.xone.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Steam
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
  ];

  # Enable Docker
  virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
