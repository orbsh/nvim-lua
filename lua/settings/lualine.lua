local term_theme = {
    terminal = {
        a = { bg = '#d79921', fg = '#282828', gui = 'bold' },
        b = { bg = '#504945', fg = '#ebdbb2' },
        c = { bg = '#7c6f64', fg = '#282828' },
    },
    inactive = {
        c = { bg = '#504945' }
    }
}

local theme
if vim.g.background == 'dark' then
    theme = require 'lualine.themes.gruvbox-material'
else
    theme = require 'lualine.themes.gruvbox_light'
end

local diag = { 'diagnostics', symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' } }

local separators = {
    component = "",
    section = ""
}

if os.getenv('NVIM_LUALINE_POWER') then
    separators = {
        component = { left = '', right = '' },
        section = { left = '', right = '' }
    }
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = theme,
        component_separators = separators.component,
        section_separators = separators.section,
        disabled_filetypes = {},
        always_divide_middle = false,
        always_show_tabline = false,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = vim.g.has_git and { 'branch', 'diff', diag } or { diag },
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 1,
            }
        },
        lualine_x = {
            {
                'fileformat',
                --symbols = { unix = 'unix', dos = 'dos', mac = 'mac' }
            },
            'encoding',
            'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = vim.g.has_git and { 'diff', diag } or { diag },
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 1,
                shorting_target = 40,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'progress', 'location' }
    },
    tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 2,
                max_length = function() return math.floor(vim.o.columns / 1.5) end,
                use_mode_color = true,
            }
        },
        lualine_b = {},
        lualine_c = { 'aerial' },
        lualine_x = {}, -- macro_recording
        lualine_y = { 'overseer' },
        lualine_z = {
            { 'windows', disabled_filetypes = vim.g.plugin_filetypes }
        }
    },
    extensions = {
        'neo-tree',
        'mundo',
        'nvim-dap-ui',
        'symbols-outline',
        'quickfix',
        'overseer',
        'aerial'
    }
}

local refresh_tabline = function()
    require('lualine').refresh {
        scope = 'all',
        place = { 'tabline' }
    }
end

vim.api.nvim_create_autocmd("VimResized", { callback = refresh_tabline })
vim.api.nvim_create_autocmd("RecordingEnter", { callback = refresh_tabline })
vim.api.nvim_create_autocmd("RecordingLeave", { callback = refresh_tabline })


vim.api.nvim_create_autocmd("DirChanged", {
    pattern = 'tabpage',
    callback = function(ctx)
        local curridx = vim.api.nvim_get_current_tabpage()
        local currname = vim.t[curridx].tabname
        if currname and string.sub(currname, 1, 1) == vim.g.tab_title_pin then return end

        local name = nil
        if vim.fs.root(ctx.file, { '.git' }) then
            name = vim.fs.basename(ctx.file)
        else
            name = vim.fn.fnamemodify(ctx.file, ':~')
        end
        vim.t[curridx].tabname = name
    end
})
