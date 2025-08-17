{config, ...}: let
  username = "bdenzy";
in {
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../secrets/ssh-keys.enc.yaml;

    secrets."ssh_config" = {
      path = "/home/${username}/.ssh/config";
      mode = "0600";
    };
    secrets."github_private_key" = {
      path = "/home/${username}/.ssh/github";
      mode = "0600";
    };
    secrets."github_public_key" = {
      path = "/home/${username}/.ssh/github.pub";
      mode = "0600";
    };
  };

  imports = [
    ../modules/fish.nix
    ../modules/git.nix
    ../modules/startship.nix
  ];
}
