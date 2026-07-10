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
    ./alacritty.nix
    ./mako.nix
    ./mangohud.nix
    ./waybar.nix
    ./wofi.nix
    ./zen.nix
  ];

  # Symlinks
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/hypr";
    recursive = true;
  };
}
