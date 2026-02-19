-- Nixvim's internal module table
-- Can be used to share code throughout init.lua
local _M = {}

-- Set up globals {{{
do
    local nixvim_globals = { mapleader = " ", maplocalleader = " ", mkdp_auto_close = 1, mkdp_auto_start = 0 }

    for k, v in pairs(nixvim_globals) do
        vim.g[k] = v
    end
end
-- }}}

-- Set up options {{{
do
    local nixvim_options = {
        breakindent = true,
        clipboard = "unnamedplus",
        cursorline = true,
        expandtab = true,
        guifont = "DejaVu Sans Mono:h13",
        ignorecase = true,
        inccommand = "split",
        list = true,
        listchars = "tab:» ,trail:·,nbsp:␣",
        mouse = "a",
        number = true,
        relativenumber = true,
        scrolloff = 10,
        shiftwidth = 2,
        showmode = false,
        signcolumn = "yes",
        smartcase = true,
        spell = true,
        splitbelow = true,
        splitright = true,
        timeoutlen = 300,
        undofile = true,
        updatetime = 250,
        wrap = false,
    }

    for k, v in pairs(nixvim_options) do
        vim.opt[k] = v
    end
end
-- }}}

require("nvim-web-devicons").setup({})

require("mini.base16").setup({
    palette = {
        base00 = "#282a36",
        base01 = "#363447",
        base02 = "#44475a",
        base03 = "#6272a4",
        base04 = "#9ea8c7",
        base05 = "#f8f8f2",
        base06 = "#f0f1f4",
        base07 = "#ffffff",
        base08 = "#ff5555",
        base09 = "#ffb86c",
        base0A = "#f1fa8c",
        base0B = "#50fa7b",
        base0C = "#8be9fd",
        base0D = "#80bfff",
        base0E = "#ff79c6",
        base0F = "#bd93f9",
    },
})

local cmp = require("cmp")
cmp.setup({
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
    },
    sources = { { name = "nvim_lsp" }, { name = "buffer" }, { name = "path" } },
})

require("which-key").setup({})

-- Create autogroup for treesitter autocmds
local augroup = vim.api.nvim_create_augroup("nixvim_treesitter", { clear = true })

-- Detect nvim-treesitter API
local has_configs_module = pcall(require, "nvim-treesitter.configs")

if has_configs_module then
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "nix", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
    })
else
    require("nvim-treesitter").setup({
        ensure_installed = { "python", "nix", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
    })

    -- Enable features via autocommands for modern nvim-treesitter
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "*",
        callback = function()
            pcall(vim.treesitter.start)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })
end

require("telescope").setup({ extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } } })

local __telescopeExtensions = { "ui-select", "fzf" }
for i, extension in ipairs(__telescopeExtensions) do
    require("telescope").load_extension(extension)
end

require("lualine").setup({})

require("gitsigns").setup({})

require("conform").setup({
    format_on_save = { lsp_format = "fallback", timeout_ms = 5000 },
    formatters_by_ft = {
        json = { "prettier" },
        markdown = { "prettier" },
        nix = { "alejandra" },
        python = { "black" },
        yaml = { "prettier" },
    },
})

if vim.g.neovide then
    vim.g.neovide_normal_opacity = 0.800000
end

-- Set up keybinds {{{
do
    local __nixvim_binds = {
        {
            action = "<cmd>Telescope buffers<cr>",
            key = "<leader><leader>",
            mode = "n",
            options = { desc = "[ ] Find existing buffers" },
        },
        {
            action = "<cmd>Telescope oldfiles<cr>",
            key = "<leader>s.",
            mode = "n",
            options = { desc = "[S]earch Recent Files ('.' for repeat)" },
        },
        {
            action = "<cmd>Telescope diagnostics<cr>",
            key = "<leader>sd",
            mode = "n",
            options = { desc = "[S]earch [D]iagnostics" },
        },
        {
            action = "<cmd>Telescope find_files<cr>",
            key = "<leader>sf",
            mode = "n",
            options = { desc = "[S]earch [F]iles" },
        },
        {
            action = "<cmd>Telescope live_grep<cr>",
            key = "<leader>sg",
            mode = "n",
            options = { desc = "[S]earch by [G]rep" },
        },
        {
            action = "<cmd>Telescope help_tags<cr>",
            key = "<leader>sh",
            mode = "n",
            options = { desc = "[S]earch [H]elp" },
        },
        {
            action = "<cmd>Telescope keymaps<cr>",
            key = "<leader>sk",
            mode = "n",
            options = { desc = "[S]earch [K]eymaps" },
        },
        {
            action = "<cmd>Telescope resume<cr>",
            key = "<leader>sr",
            mode = "n",
            options = { desc = "[S]earch [R]esume" },
        },
        {
            action = "<cmd>Telescope builtin<cr>",
            key = "<leader>ss",
            mode = "n",
            options = { desc = "[S]earch [S]elect Telescope" },
        },
        {
            action = "<cmd>Telescope grep_string<cr>",
            key = "<leader>sw",
            mode = "n",
            options = { desc = "[S]earch current [W]ord" },
        },
        { action = "<cmd>nohlsearch<CR>", key = "<Esc>", mode = { "n" } },
        { action = "<C-d>zz", key = "<C-d>", mode = { "n" } },
        { action = "<C-u>zz", key = "<C-u>", mode = { "n" } },
        { action = "<cmd>lua vim.lsp.buf.definition()<CR>", key = "gd", mode = "n" },
    }
    for i, map in ipairs(__nixvim_binds) do
        vim.keymap.set(map.mode, map.key, map.action, map.options)
    end
end
-- }}}

-- LSP {{{
do
    vim.lsp.inlay_hint.enable(true)
    local __lspCapabilities = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        return capabilities
    end

    local __setup = { capabilities = __lspCapabilities() }

    local __wrapConfig = function(cfg)
        if cfg == nil then
            cfg = __setup
        else
            cfg = vim.tbl_extend("keep", cfg, __setup)
        end
        return cfg
    end

    vim.lsp.config("markdown_oxide", __wrapConfig({}))
    vim.lsp.enable("markdown_oxide")
    vim.lsp.config("nixd", __wrapConfig({}))
    vim.lsp.enable("nixd")
    vim.lsp.config("pyright", __wrapConfig({}))
    vim.lsp.enable("pyright")
end
-- }}}

vim.opt.spelllang = { "en_us" }

-- Set up autogroups {{
do
    local __nixvim_autogroups = { nixvim_binds_LspAttach = { clear = true }, nixvim_lsp_on_attach = { clear = false } }

    for group_name, options in pairs(__nixvim_autogroups) do
        vim.api.nvim_create_augroup(group_name, options)
    end
end
-- }}
-- Set up autocommands {{
do
    local __nixvim_autocommands = {
        {
            callback = function(event)
                do
                    -- client and bufnr are supplied to the builtin `on_attach` callback,
                    -- so make them available in scope for our global `onAttach` impl
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local bufnr = event.buf
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
                        } or {},
                        virtual_text = {
                            source = "if_many",
                            spacing = 2,
                            format = function(diagnostic)
                                local code = diagnostic.code and ("[" .. diagnostic.code .. "] ") or ""
                                local diagnostic_message = {
                                    [vim.diagnostic.severity.ERROR] = code .. diagnostic.message,
                                    [vim.diagnostic.severity.WARN] = code .. diagnostic.message,
                                    [vim.diagnostic.severity.INFO] = code .. diagnostic.message,
                                    [vim.diagnostic.severity.HINT] = code .. diagnostic.message,
                                }
                                return diagnostic_message[diagnostic.severity]
                            end,
                        },
                    })
                end
            end,
            desc = "Run LSP onAttach",
            event = "LspAttach",
            group = "nixvim_lsp_on_attach",
        },
        {
            callback = function(args)
                do
                    local __nixvim_binds = {}

                    for i, map in ipairs(__nixvim_binds) do
                        local options = vim.tbl_extend("keep", map.options or {}, { buffer = args.buf })
                        vim.keymap.set(map.mode, map.key, map.action, options)
                    end
                end
            end,
            desc = "Load keymaps for LspAttach",
            event = "LspAttach",
            group = "nixvim_binds_LspAttach",
        },
    }

    for _, autocmd in ipairs(__nixvim_autocommands) do
        vim.api.nvim_create_autocmd(autocmd.event, {
            group = autocmd.group,
            pattern = autocmd.pattern,
            buffer = autocmd.buffer,
            desc = autocmd.desc,
            callback = autocmd.callback,
            command = autocmd.command,
            once = autocmd.once,
            nested = autocmd.nested,
        })
    end
end
-- }}
