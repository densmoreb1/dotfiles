{...}: {
  home.username = "brandon";
  home.homeDirectory = "/home/brandon";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      "l" = "ls -lavh";
      "ll" = "ls -lh";
      "gs" = "git status";
      "t" = "tree";
      "ip" = "ip --color=auto";
      "v" = "nvim";
    };
    shellInit = ''
      function starship_transient_prompt_func
        starship module character
      end

      set -g fish_key_bindings fish_vi_key_bindings
      set fish_greeting

      starship init fish | source
      enable_transience
    '';
  };

  programs.home-manager.enable = true;

  # Use dotfiles repo for now
  # all go in ~/.config
  xdg.configFile."task/taskrc".source = ../../.config/task/taskrc;
  xdg.configFile."alacritty/alacritty.toml".source = ../../.config/alacritty/alacritty.toml;
  xdg.configFile."black/pyproject.toml".source = ../../.config/black/pyproject.toml;
  xdg.configFile."hypr/hyprland.conf".source = ../../.config/hypr/hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ../../.config/hypr/hyprpaper.conf;
  xdg.configFile."qutebrowser/config.py".source = ../../.config/qutebrowser/config.py;
  xdg.configFile."waybar/config".source = ../../.config/waybar/config;
  xdg.configFile."waybar/style.css".source = ../../.config/waybar/style.css;
  xdg.configFile."wofi/nord.css".source = ../../.config/wofi/nord.css;

  # Converted
  imports = [
    ../modules/git.nix
    ../modules/startship.nix
    ../modules/nixvim.nix
  ];
}
