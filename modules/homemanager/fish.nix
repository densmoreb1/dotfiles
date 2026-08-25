{...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      "l" = "ls -lavh";
      "ll" = "ls -lh";
      "gs" = "git status";
      "ip" = "ip --color=auto";
      "gsp" = "git stash; git pull; git stash pop";
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
}
