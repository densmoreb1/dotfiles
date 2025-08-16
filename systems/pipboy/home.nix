{...}: {
  home.username = "bdenzy";
  home.homeDirectory = "/home/bdenzy";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      "l" = "ls -lavh";
      "ll" = "ls -lh";
      "gs" = "git status";
      "t" = "tree";
      "ip" = "ip --color=auto";
      "v" = "nvim";
    };
    shellInit = ''
      function starship_transient_prompt_func
        starship module character
      end

      set -g fish_key_bindings fish_vi_key_bindings
      set fish_greeting

      starship init fish | source
      enable_transience
    '';
  };

  programs.home-manager.enable = true;

  imports = [
    ../modules/startship.nix
  ];
}
