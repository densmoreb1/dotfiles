{
  config,
  pkgs,
  ...
}: {
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
  };
}
