{...}: let
  username = "bdenzy";
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  programs.home-manager.enable = true;

  imports = [
    ../modules/fish.nix
    ../modules/git.nix
    ../modules/startship.nix
  ];
}
