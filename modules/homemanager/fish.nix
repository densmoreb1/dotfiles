{lib, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      "l" = "ls -lavh";
      "ll" = "ls -lh";
      "gs" = "git status";
      "ip" = "ip --color=auto";
      "gsp" = "git stash; git pull; git stash pop";
    };
    functions.starship_transient_prompt_func = "starship module character";
    interactiveShellInit = lib.mkAfter ''
      set -g fish_key_bindings fish_vi_key_bindings
      set fish_greeting

      enable_transience
    '';
  };
}
