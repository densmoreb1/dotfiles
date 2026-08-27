{...}: {
  # Generates LS_COLORS from the stylix base16 palette and exports it in fish.
  # Without this, `ls` falls back to GNU's built-in defaults, which ignore the
  # theme entirely and just use the terminal's ANSI slots.
  programs.vivid = {
    enable = true;
    colorMode = "24-bit";
  };
}
