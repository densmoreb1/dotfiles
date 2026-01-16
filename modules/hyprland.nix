{...}: {
  # Login
  services.displayManager.ly.enable = true;

  # Desktop
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
