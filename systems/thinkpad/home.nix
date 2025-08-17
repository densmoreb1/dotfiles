{config, ...}: let
  username = "brandon";
in {
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Converted
  imports = [
    ../modules/alacritty.nix
    ../modules/fish.nix
    ../modules/git.nix
    ../modules/nixvim.nix
    ../modules/startship.nix
    ../modules/taskwarrior.nix
  ];

  # Use dotfiles repo for now
  # all go in ~/.config
  xdg.configFile."black/pyproject.toml".source = ../../.config/black/pyproject.toml;
  xdg.configFile."hypr/hyprland.conf".source = ../../.config/hypr/hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ../../.config/hypr/hyprpaper.conf;
  xdg.configFile."qutebrowser/config.py".source = ../../.config/qutebrowser/config.py;
  xdg.configFile."waybar/config".source = ../../.config/waybar/config;
  xdg.configFile."waybar/style.css".source = ../../.config/waybar/style.css;
  xdg.configFile."wofi/nord.css".source = ../../.config/wofi/nord.css;

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../modules/ssh-keys.enc.yaml;

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
    secrets."pass_private_key" = {
      path = "/home/${username}/.ssh/pass";
      mode = "0600";
    };
    secrets."pass_public_key" = {
      path = "/home/${username}/.ssh/pass.pub";
      mode = "0600";
    };
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
}
