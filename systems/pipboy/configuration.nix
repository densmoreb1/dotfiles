{...}: {
  imports = [
    ../../modules/system/default.nix
  ];

  networking.hostName = "pipboy";

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";
}
