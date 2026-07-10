{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/hyprland.nix
    ../../modules/system/mail.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/default.nix
    ../../modules/system/style.nix
  ];

  networking.hostName = "rose";

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "25.11";
}
