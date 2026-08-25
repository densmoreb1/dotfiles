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

  # Everything under .config/hypr is now Nix-generated: hyprland.lua by
  # ./hyprland.nix, hyprpaper.conf by ./hyprpaper.nix (via the stylix
  # hyprpaper target) -- no manual symlinks needed here anymore.
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
