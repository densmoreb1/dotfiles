{
  config,
  username,
  ...
}: {
  sops = {
    secrets."pipboy_private_key" = {
      path = "/home/${username}/.ssh/pipboy";
      mode = "0600";
    };
    secrets."pipboy_public_key" = {
      path = "/home/${username}/.ssh/pipboy.pub";
      mode = "0600";
    };
  };

  imports = [
    ../homemanager/alacritty.nix
    ../homemanager/mako.nix
    ../homemanager/mangohud.nix
    ../homemanager/wofi.nix
    ../homemanager/qutebrowser.nix
  ];

  # Symlinks
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";
    recursive = true;
  };
  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/waybar";
    recursive = true;
  };
}
