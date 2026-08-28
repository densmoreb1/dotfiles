{...}: {
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      no_actions = true;
    };
  };
}
