{...}: {
  programs.alacritty = {
    enable = true;
    theme = "dracula_plus";
    settings = {
      font.size = 13;
      font.normal.family = "JetbrainsMono Nerd Font";
      window.opacity = 0.9;
    };
  };
}
