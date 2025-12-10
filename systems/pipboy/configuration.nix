{pkgs, ...}: {
  networking.hostName = "pipboy";
  networking.firewall.enable = false;

  services.tlp.enable = true;
  services.openssh = {
    enable = true;
    ports = [6977];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = ["bdenzy"];
      PermitRootLogin = "no";
    };
  };

  users.users.bdenzy = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgjGHn32ltSLOtejcPrFpo/BIErzcyqyr0q4tUY2une brandon@archlinux"];
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker
  ];

  system.stateVersion = "24.11";
}
