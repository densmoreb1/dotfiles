{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Brandon Densmore";
      user.email = "hens.tippet.1o@icloud.com";
      init.defaultBranch = "main";
      core.pager = "less -F -X";
    };
  };
}
