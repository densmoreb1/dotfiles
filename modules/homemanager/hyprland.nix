{...}: {
  # Hyprland is installed via the NixOS module (modules/system/hyprland.nix),
  # so `package`/`portalPackage` are left null here to avoid a second install
  # and to avoid opting into home-manager's xdg-portal wiring as a side effect.
  #
  # extraConfig is read from ../../.config/hypr/hyprland.lua rather than
  # inlined, so that file stays the single source of truth to edit. Border/
  # shadow colors were removed from its `general`/`decoration` blocks so
  # stylix's `hyprland` target (which writes its own hl.config({...}) call
  # via `settings.config`) is the only thing setting them. Note this is still
  # baked in at eval time -- editing hyprland.lua still requires a rebuild to
  # take effect, same as before; it's just no longer embedded as a Nix string.
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";

    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
