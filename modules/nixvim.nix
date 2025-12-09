{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    ripgrep
    # formatters
    alejandra
    black
    nodePackages.prettier
  ];

  programs.nixvim = {
    enable = true;
    enableMan = true;

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    keymaps = [
      {
        action = "<cmd>nohlsearch<CR>";
        key = "<Esc>";
        mode = ["n"];
      }
      {
        action = "<C-d>zz";
        key = "<C-d>";
        mode = ["n"];
      }
      {
        action = "<C-u>zz";
        key = "<C-u>";
        mode = ["n"];
      }
    ];

    opts = {
      breakindent = true;
      clipboard = "unnamedplus";
      cursorline = true;
      expandtab = true;
      ignorecase = true;
      inccommand = "split";
      list = true;
      listchars = "tab:» ,trail:·,nbsp:␣";
      mouse = "a";
      number = true;
      relativenumber = true;
      scrolloff = 10;
      shiftwidth = 2;
      showmode = false;
      signcolumn = "yes";
      smartcase = true;
      spell = true;
      splitbelow = true;
      splitright = true;
      timeoutlen = 300;
      undofile = true;
      updatetime = 250;
      wrap = false;
    };

    extraConfigLua = ''
      vim.opt.spelllang = { 'en_us' }
    '';

    plugins = {
      # status line
      lualine.enable = true;

      # Completion for all lsps
      cmp-nvim-lsp.enable = true;

      # Enable git signs on the left side
      gitsigns.enable = true;

      # pop up for key maps
      which-key.enable = true;

      # required for telescope
      web-devicons.enable = true;

      markdown-preview = {
        enable = true;
        # Optional: auto start preview on entering markdown buffer
        settings = {
          auto_start = 0;
          auto_close = 1;
        };
      };

      # lsp are install by their default package
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          markdown_oxide.enable = true;
        };

        # Creates the floating dialog
        onAttach = ''
            vim.diagnostic.config {
              severity_sort = true,
              float = { border = 'rounded', source = 'if_many' },
              underline = { severity = vim.diagnostic.severity.ERROR },
              signs = {
                text = {
                  [vim.diagnostic.severity.ERROR] = '󰅚 ',
                  [vim.diagnostic.severity.WARN] = '󰀪 ',
                  [vim.diagnostic.severity.INFO] = '󰋽 ',
                  [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
              } or {},
              virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                local code = diagnostic.code and ("[" .. diagnostic.code .. "] ") or ""
                    local diagnostic_message = {
                       [vim.diagnostic.severity.ERROR] = code .. diagnostic.message,
                       [vim.diagnostic.severity.WARN]  = code .. diagnostic.message,
                       [vim.diagnostic.severity.INFO]  = code .. diagnostic.message,
                       [vim.diagnostic.severity.HINT]  = code .. diagnostic.message,
                    }
                  return diagnostic_message[diagnostic.severity]
                end,
              },
          }
        '';
      };

      # formatters need to be installed
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            python = ["black"];
            nix = ["alejandra"];
            markdown = ["prettier"];
            json = ["prettier"];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_format = "fallback";
          };
        };
      };

      # Completion for all text
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "buffer";}
            {name = "path";}
          ];
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
        };
      };

      # Syntax, Indentation
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "python"
            "nix"
            "markdown"
          ];
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        keymaps = {
          "<leader>sh" = {
            mode = "n";
            action = "help_tags";
            options = {
              desc = "[S]earch [H]elp";
            };
          };
          "<leader>sk" = {
            mode = "n";
            action = "keymaps";
            options = {
              desc = "[S]earch [K]eymaps";
            };
          };
          "<leader>sf" = {
            mode = "n";
            action = "find_files";
            options = {
              desc = "[S]earch [F]iles";
            };
          };
          "<leader>ss" = {
            mode = "n";
            action = "builtin";
            options = {
              desc = "[S]earch [S]elect Telescope";
            };
          };
          "<leader>sw" = {
            mode = "n";
            action = "grep_string";
            options = {
              desc = "[S]earch current [W]ord";
            };
          };
          "<leader>sg" = {
            mode = "n";
            action = "live_grep";
            options = {
              desc = "[S]earch by [G]rep";
            };
          };
          "<leader>sd" = {
            mode = "n";
            action = "diagnostics";
            options = {
              desc = "[S]earch [D]iagnostics";
            };
          };
          "<leader>sr" = {
            mode = "n";
            action = "resume";
            options = {
              desc = "[S]earch [R]esume";
            };
          };
          "<leader>s." = {
            mode = "n";
            action = "oldfiles";
            options = {
              desc = "[S]earch Recent Files ('.' for repeat)";
            };
          };
          "<leader><leader>" = {
            mode = "n";
            action = "buffers";
            options = {
              desc = "[ ] Find existing buffers";
            };
          };
        };
        settings = {
          extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
        };
      };
    };
  };
}
