{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/ddclient.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "pipboy";

  virtualisation.docker.enable = true;

  system.stateVersion = "24.11";
}
