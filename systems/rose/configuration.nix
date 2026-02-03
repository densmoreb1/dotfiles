{
  jovian,
  username,
  ...
}: {
  imports = [
    jovian.nixosModules.default
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
