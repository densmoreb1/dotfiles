{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";

    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
