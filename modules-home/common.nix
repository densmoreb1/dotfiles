{
  config,
  username,
  ...
}: {
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  imports = [
    ../modules-home/fish.nix
    ../modules-home/git.nix
    ../modules-home/nixvim.nix
    ../modules-home/starship.nix
  ];

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
}
