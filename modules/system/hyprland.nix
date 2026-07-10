{pkgs, ...}: {
  # Login
  services.displayManager.ly.enable = true;

  # Desktop
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Gaming
  programs.steam.enable = true;
  hardware.xone.enable = true; # Xbox controller

  # Packages
  environment.systemPackages = with pkgs; [
    bibata-cursors
    brightnessctl
    claude-code
    heroic
    hyprpaper
    libnotify # notifications
    localsend
    python313
    qFlipper
    thunar
    waybar
    wl-clipboard
    wofi # app launcher

    # Pass password manager
    gnupg
    pass
    pinentry-qt
    wofi-pass
  ];
}
