{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "brandon";
  home.homeDirectory = "/home/brandon";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Use dotfiles repo for now
  # all go in ~/.config
  xdg.configFile."task/taskrc".source = ../../.config/task/taskrc;
  xdg.configFile."alacritty/alacritty.toml".source = ../../.config/alacritty/alacritty.toml;
  xdg.configFile."black/pyproject.toml".source = ../../.config/black/pyproject.toml;
  xdg.configFile."fish/config.fish".source = ../../.config/fish/config.fish;
  xdg.configFile."hypr/hyprland.conf".source = ../../.config/hypr/hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ../../.config/hypr/hyprpaper.conf;
  xdg.configFile."pycodestyle".source = ../../.config/pycodestyle;
  xdg.configFile."qutebrowser/config.py".source = ../../.config/qutebrowser/config.py;
  xdg.configFile."waybar/config".source = ../../.config/waybar/config;
  xdg.configFile."waybar/style.css".source = ../../.config/waybar/style.css;
  xdg.configFile."wofi/nord.css".source = ../../.config/wofi/nord.css;

  # Converted
  imports = [
    ./packages/git.nix
    ./packages/startship.nix
    ./packages/nixvim.nix
  ];
}
