{pkgs, ...}: {
  networking.hostName = "pipboy";
  networking.firewall.enable = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker
  ];

  system.stateVersion = "24.11";
}
