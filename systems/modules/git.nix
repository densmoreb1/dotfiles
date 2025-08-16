{...}: {
  programs.git = {
    enable = true;
    userName = "Brandon Densmore";
    userEmail = "densmoreb1@icloud.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.pager = "less -F -X";
    };
  };
}
