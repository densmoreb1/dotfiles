{...}: {
  home.username = "bdenzy";
  home.homeDirectory = "/home/bdenzy";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # Use dotfiles repo for now
  # all go in ~/.config
  xdg.configFile."fish/config.fish".source = ../../.config/fish/config.fish;

  # Converted
  imports = [
    ../modules/startship.nix
  ];
}
