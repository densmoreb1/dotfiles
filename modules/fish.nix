{...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      "l" = "ls -lavh";
      "ll" = "ls -lh";
      "gs" = "git status";
      "t" = "tree";
      "ip" = "ip --color=auto";
      "v" = "nvim";
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
    shellInitLast = ''
      set -U fish_color_normal f8f8f2
      set -U fish_color_command 8be9fd
      set -U fish_color_keyword ff79c6
      set -U fish_color_quote f1fa8c
      set -U fish_color_redirection f8f8f2
      set -U fish_color_end ffb86c
      set -U fish_color_error ff5555
      set -U fish_color_param bd93f9
      set -U fish_color_comment 6272a4
      set -U fish_color_selection --bold --background=44475a
      set -U fish_color_search_match --bold --background=44475a
      set -U fish_color_history_current --bold
      set -U fish_color_operator 50fa7b
      set -U fish_color_escape ff79c6
      set -U fish_color_cwd 50fa7b
      set -U fish_color_cwd_root red
      set -U fish_color_option ffb86c
      set -U fish_color_valid_path --underline=single
      set -U fish_color_autosuggestion 6272a4
      set -U fish_color_user 8be9fd
      set -U fish_color_host bd93f9
      set -U fish_color_host_remote bd93f9
      set -U fish_color_history_current --bold
      set -U fish_color_status ff5555
      set -U fish_color_cancel ff5555 --reverse
      set -U fish_pager_color_background
      set -U fish_pager_color_prefix 8be9fd
      set -U fish_pager_color_progress 6272a4
      set -U fish_pager_color_completion f8f8f2
      set -U fish_pager_color_description 6272a4
      set -U fish_pager_color_selected_background --background=44475a
      set -U fish_pager_color_selected_prefix 8be9fd
      set -U fish_pager_color_selected_completion f8f8f2
      set -U fish_pager_color_selected_description 6272a4
      set -U fish_pager_color_secondary_background
      set -U fish_pager_color_secondary_prefix
      set -U fish_pager_color_secondary_description
      set -U fish_pager_color_secondary_completion
    '';
  };
}
