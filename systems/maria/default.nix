{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "maria";

  environment.systemPackages = with pkgs; [
    mergerfs
  ];

  system.stateVersion = "24.11";
}
