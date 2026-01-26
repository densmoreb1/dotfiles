{...}: {
  networking.hostName = "maria";

  boot.kernelParams = ["nomodeset"];
  systemd.tpm2.enable = false;
  services.xserver.enable = false;

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";
}
