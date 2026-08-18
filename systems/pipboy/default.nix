{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/router.nix
    ../../modules/system/ddclient.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "pipboy";

  system.stateVersion = "24.11";
}
