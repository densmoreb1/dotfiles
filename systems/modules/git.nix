{...}: {
  programs.git = {
    enable = true;
    userName = "Brandon Densmore";
    userEmail = "hens.tippet.1o@icloud.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.pager = "less -F -X";
    };
  };
}
