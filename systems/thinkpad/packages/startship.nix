{
  config,
  pkgs,
  ...
}: {
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
