{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gcc
    # formatters
    black
    alejandra
  ];

  programs.nixvim = {
    enable = true;
    enableMan = true;

    colorschemes.catppuccin.enable = true;

    globals.mapleader = " ";
    keymaps = [
      {
        action = "<cmd>nohlsearch<CR>";
        key = "<Esc>";
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
      lualine.enable = true;

      # lsp are install by their default package
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd.enable = true;
          pyright = {
            enable = true;
            settings = {
              python = {
                analysis = {
                  reportPossiblyUnboundVariable = false; # disable "variable is possibly unbound"
                };
              };
            };
          };
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
                local diagnostic_message = {
                   [vim.diagnostic.severity.ERROR] = diagnostic.message,
                   [vim.diagnostic.severity.WARN] = diagnostic.message,
                   [vim.diagnostic.severity.INFO] = diagnostic.message,
                   [vim.diagnostic.severity.HINT] = diagnostic.message,
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

      # Completion for all lsp
      cmp-nvim-lsp.enable = true;

      # Enable git signs on the left side
      gitsigns.enable = true;

      # Syntax, Indentation
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [
            "python"
            "nix"
          ];
          highlight.enable = true;
          indent.enable = true;
        };
      };
    };
  };
}
