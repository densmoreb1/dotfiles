{
  config,
  username,
  ...
}: {
  sops = {
    secrets."hyprapp_private_key" = {
      path = "/home/${username}/.ssh/hyprapp";
      mode = "0600";
    };
    secrets."hyprapp_public_key" = {
      path = "/home/${username}/.ssh/hyprapp.pub";
      mode = "0600";
    };
    secrets."pipboy_private_key" = {
      path = "/home/${username}/.ssh/pipboy";
      mode = "0600";
    };
    secrets."pipboy_public_key" = {
      path = "/home/${username}/.ssh/pipboy.pub";
      mode = "0600";
    };
  };

  # Converted
  imports = [
    ../../modules/alacritty.nix
    ../../modules/neomutt.nix
    ../../modules/taskwarrior.nix
  ];

  # Use dotfiles repo for now
  # all go in ~/.config
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";
    recursive = true;
  };
  xdg.configFile."neomutt" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/neomutt";
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
}
