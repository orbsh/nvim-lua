local h = require('lazy_helper')

return {
    {
        'moonbit-community/moonbit.nvim',
        ft = { 'moonbit' },
        opts = {
            mooncakes = {
                virtual_text = true,
                use_local = true,
            },
            treesitter = {
                enabled = true,
                auto_install = true
            },
            lsp = {
                on_attach = function(client, bufnr) end,
                capabilities = vim.lsp.protocol.make_client_capabilities(),
            }
        },
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        enabled = vim.g.nvim_level >= 3,
    },
    {
        "nvim-neorg/neorg",
        --build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = h.settings 'neorg',
        enabled = false
    },
    {
        'nvim-orgmode/orgmode',
        keys = {
            { '<leader>oa', nil, desc = 'orgmode agenda' },
            { '<leader>oc', nil, desc = 'orgmode capture' },
        },
        ft = { 'org' },
        config = h.settings 'orgmode',
        enabled = false,
    },
    {
        'towolf/vim-helm',
        enabled = vim.g.nvim_level >= 3,
    },
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        build = 'cd app && npm install',
    },
}
