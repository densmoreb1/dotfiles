{pkgs, ...}: {
  # Login
  services.displayManager.ly.enable = true;

  # Desktop
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}
