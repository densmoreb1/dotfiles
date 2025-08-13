{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "brandon";
  home.homeDirectory = "/home/brandon";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Brandon Densmore";
    userEmail = "densmoreb1@icloud.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.pager = "less -F -X";
      core.editor = "nvim";
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      git_status.ahead = "⇡\${count}";
      git_status.diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      git_status.behind = "⇣\${count}";
      git_branch.style = "bold blue";
      python.symbol = "󰌠 ";
      hostname.format = "[$ssh_symbol](bold blue)on [$hostname](bold red) ";
      hostname.disabled = false;
    };
  };
}
