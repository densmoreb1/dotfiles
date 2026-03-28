{pkgs, ...}: {
  # styling
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    opacity = {
      terminal = 0.8;
      applications = 0.8;
    };
    fonts = {
      sizes.terminal = 13;
      serif.package = pkgs.nerd-fonts.jetbrains-mono;
      sansSerif.package = pkgs.nerd-fonts.jetbrains-mono;
      monospace.package = pkgs.nerd-fonts.jetbrains-mono;
      emoji.package = pkgs.noto-fonts-color-emoji;
    };
  };
}
