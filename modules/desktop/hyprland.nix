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
    firefox
    heroic
    hyprpaper
    localsend
    mangohud
    python313
    qFlipper
    qutebrowser
    thunar
    waybar
    wirelesstools
    wl-clipboard
    wofi # app launcher

    # Pass password manager
    gnupg
    pass
    pinentry-qt
    wofi-pass
  ];
}
