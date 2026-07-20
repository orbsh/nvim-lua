local h = require('lazy_helper')
local m = require('setup').mod

return {
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        config = h.settings 'luasnip',
    },

    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        config = h.settings 'blink_cmp',
        enabled = vim.g.nvim_level >= 2,
    },
    {
        'neovim/nvim-lspconfig',
        keys = {
            { 'gd',  'declaration',             remap = true },
            { ';x',  'references',              remap = true },
            { ';d',  'definition',              remap = true },
            { 'K',   'hover',                   remap = true },
            { 'gi',  'implementation',          remap = true },
            { ';k',  'signature_help',          remap = true },
            { ';wa', 'add_workspace_folder',    remap = true },
            { ';wr', 'remove_workspace_folder', remap = true },
            { ';wl', 'list_workspace_folders',  remap = true },
            { ';D',  'type_definition',         remap = true },
            { ';r',  'rename',                  remap = true },
            { ';a',  'code_action',             remap = true },
            { ';f',  'format',                  remap = true },
            { ';o',  'open_float' },
            { ';p',  'goto_prev' },
            { ';n',  'goto_next' },
            { ';l',  'setloclist' },
        },
        config = h.settings 'lsp',
        enabled = vim.g.nvim_level >= 2,
        lazy = false,
    },
    {
        'mfussenegger/nvim-dap',
        enabled = vim.g.nvim_level >= 2,
        lazy = true,
    },
    {
        'rcarriga/nvim-dap-ui',
        keys = {
            { ',b', 'toggle_breakpoint' },
            { ',l', 'list_breakpoints' },
            { ',B', 'condition_breakpoint' },
            { ',L', 'log_breakpoint' },
            { ',c', 'continue' },
            { ',s', 'step_over' },
            { ',g', 'goto_' },
            { ',i', 'step_into' },
            { ',o', 'step_out' },
            { ',r', 'run_to_cursor' },
            { ',X', 'repl_open' },
            { ',C', 'run_last' },
            { ',x', 'stop' },
            { ',v', 'eval',                mode = { 'n', 'v' } },
        },
        config = h.settings 'dap',
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio',
        },
        enabled = vim.g.nvim_level >= 2,
        lazy = true,
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        enabled = false,
        dependencies = { 'mfussenegger/nvim-dap' }
    },

    {
        'stevearc/aerial.nvim',
        keys = {
            {
                '<C-s>',
                '<cmd>AerialToggle!<CR>',
                desc = 'AerialTelescope'
            },
            {
                '<leader>s',
                function() require("telescope").extensions.aerial.aerial() end,
                desc = 'AerialToggle'
            }
        },
        config = h.settings 'aerial',
        enabled = vim.g.nvim_level >= 2,
    },

    {
        'romus204/tree-sitter-manager.nvim',
        config = h.settings 'treesitter',
        enabled = vim.g.nvim_level >= 2,
    },
    {
        'b0o/schemastore.nvim',
        enabled = vim.g.nvim_level >= 2,
    },
    --[=[
    'kabouzeid/nvim-lspinstall',
    'nvim-lua/lsp-status.nvim',
    'nvim-lua/lsp_extensions.nvim',
    --]=]
    --[[
    {
        'simrat39/symbols-outline.nvim',
        --enabled = vim.g.nvim_level >= 'core',
        config = function(plugin)
            --vim.opt.rtp:append(plugin.dir)
            require 'plugins.outline'
        end
    },
    --]]
    {
        'mizlan/iswap.nvim',
        dependencies = { 'romus204/tree-sitter-manager.nvim' },
        config = h.settings 'swap',
        enabled = vim.g.nvim_level >= 2,
    },

    {
        "folke/trouble.nvim",
        keys = {
            { '<leader>gw', '<cmd>Trouble diagnostics toggle<cr>',                        desc = 'Diagnostics (Trouble)' },
            { '<leader>gs', '<cmd>Trouble symbols toggle focus=false<cr>',                desc = 'Symbols (Trouble)' },
            { '<leader>gl', '<cmd>Trouble loclist toggle<cr>',                            desc = 'Location List (Trouble)' },
            { '<leader>gq', '<cmd>Trouble qflist toggle<cr>',                             desc = 'Quickfix List (Trouble)' },
            { '<leader>gr', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
        },
        opts = {},
        enabled = vim.g.nvim_level >= 2,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim"
        },
        keys = {
            { '<leader>ga', '<cmd>TodoTelescope<cr>', desc = 'TodoTelescope' },
            { '<leader>gt', '<cmd>TodoTrouble<cr>',   desc = 'TodoTrouble' },
        },
        opts = {},
        enabled = vim.g.nvim_level >= 2,
    },
}
