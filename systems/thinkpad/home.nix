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
    ../../modules/alacritty.nix
    ../../modules/fish.nix
    ../../modules/git.nix
    ../../modules/nixvim.nix
    ../../modules/startship.nix
    ../../modules/taskwarrior.nix
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

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/ssh-keys.enc.yaml;

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
