-- Standalone port of modules/homemanager/nixvim.nix for use outside Nix
-- (e.g. mounted into a Docker container's ~/.config/nvim).
--
-- Nix normally installs these CLI tools for you (see home.packages in
-- nixvim.nix) -- in a container you need to install them yourself:
--   ripgrep, gcc (treesitter needs a C compiler)
--   formatters: stylua, black, mdformat, alejandra, yq
-- LSP servers (nixd, pyright, markdown_oxide) are installed automatically
-- below via mason.nvim instead of Nix.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- options --------------------------------------------------------------

local opt = vim.opt
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.expandtab = true
opt.ignorecase = true
opt.inccommand = "split"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10
opt.shiftwidth = 2
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.spell = true
opt.spelllang = { "en_us" }
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 250
opt.wrap = false

-- keymaps ----------------------------------------------------------------

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "gd", vim.lsp.buf.definition)
map("n", "<leader>nd", "<cmd>VimwikiMakeDiaryNote<CR>", { desc = "Today's diary" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>e", function()
  require("mini.files").open()
end, { desc = "Open file explorer" })

-- lazy.nvim bootstrap ------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins ------------------------------------------------------------------

require("lazy").setup({
  { "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = { { path = "~/notes", syntax = "markdown", ext = ".md" } }
    end,
  },

  -- mini.nvim: statusline, pairs, comment, icons, surround, ai, files
  {
    "echasnovski/mini.nvim",
    priority = 100, -- load before telescope needs the devicons mock
    config = function()
      require("mini.statusline").setup()
      require("mini.pairs").setup()
      require("mini.comment").setup()
      require("mini.surround").setup()
      require("mini.ai").setup()
      require("mini.files").setup()

      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },

  "lewis6991/gitsigns.nvim",
  { "folke/which-key.nvim", event = "VeryLazy" },

  { "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,
  },

  -- LSP: mason installs the servers, lspconfig wires them up
  { "mason-org/mason.nvim", opts = {} },
  { "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "nixd", "pyright", "markdown_oxide" },
    },
  },

  -- formatting
  { "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "mdformat" },
        nix = { "alejandra" },
        python = { "black" },
        vimwiki = { "mdformat" },
        yaml = { "yq" },
      },
      formatters = {
        yq = { command = "yq", args = { "." } },
        stylua = { command = "stylua", args = { "--indent-type", "Spaces", "-" } },
      },
      format_on_save = { timeout_ms = 5000, lsp_format = "fallback" },
    },
  },

  -- completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
        }),
      })
    end,
  },

  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "python", "nix", "markdown" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      local builtin = require("telescope.builtin")
      map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      map("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
      map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
    end,
  },
}, {
  install = { colorscheme = { "habamax" } },
})

-- diagnostics --------------------------------------------------------------

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local code = diagnostic.code and ("[" .. diagnostic.code .. "] ") or ""
      return code .. diagnostic.message
    end,
  },
})

-- mason-lspconfig auto-enables installed servers via vim.lsp.enable();
-- this just merges in cmp's capabilities for all of them.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
