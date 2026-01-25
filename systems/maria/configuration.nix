{...}: {
  networking.hostName = "maria";

  boot.kernelParams = ["nomodeset"];
  services.xserver.enable = false;

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";
}
