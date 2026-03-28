{lib, ...}: {
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      toggle_hud = "Shift_L+F12";
      toggle_hud_position = "Shift_L+F11";
      toggle_preset = "Shift_L+F1";
      toggle_logging = "Shift_L+F2";
      reset_fps_metrics = "Shift_L+f9";
      background_alpha = lib.mkForce 0.5;
      alpha = lib.mkForce 1.0;
    };
  };
}
