{...}: {
  services.hyprpaper = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };
}
