{
  jovian,
  username,
  ...
}: {
  imports = [
    jovian.nixosModules.default
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/mail.nix
    ../../modules/desktop/remove-cookies.nix
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
  jovian = {
    steam.enable = true;
    steam.user = username;
    hardware.has.amd.gpu = true;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  system.stateVersion = "25.11";
}
