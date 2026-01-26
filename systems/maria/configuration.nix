{...}: {
  networking.hostName = "maria";

  systemd.tpm2.enable = false;

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";
}
