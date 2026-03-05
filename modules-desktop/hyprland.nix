{pkgs, ...}: {
  # Login
  services.displayManager.ly.enable = true;

  # Desktop
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [
    bibata-cursors
    brightnessctl
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
    twingate

    # Pass password manager
    gnupg
    pass
    pinentry-qt
    wofi-pass
  ];
}
