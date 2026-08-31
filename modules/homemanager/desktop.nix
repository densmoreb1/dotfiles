{username, ...}: {
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
    ./hyprland.nix
    ./hyprpaper.nix
    ./mako.nix
    ./mangohud.nix
    ./waybar.nix
    ./wofi.nix
    ./zen.nix
  ];
}
