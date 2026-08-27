{pkgs, ...}: {
  # styling
  stylix = {
    enable = true;
    image = ../../wallpapers/breno-machado-in9-n0JwgZ0-unsplash.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/bright.yaml";
    opacity = {
      terminal = 0.8;
      applications = 0.8;
    };
    fonts = {
      sizes.terminal = 13;
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
