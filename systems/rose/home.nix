{config, ...}: {
  # Converted
  imports = [
    ../../modules/alacritty.nix
  ];

  # Use dotfiles repo for now
  # all go in ~/.config
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";
    recursive = true;
  };
  xdg.configFile."qutebrowser/config.py" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/qutebrowser/config.py";
  };
  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/waybar";
    recursive = true;
  };
  xdg.configFile."wofi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/wofi";
    recursive = true;
  };

  xdg.configFile."black/pyproject.toml".source = ../../.config/black/pyproject.toml;
}
