local font = require('font')
vim.opt.guicursor:append { 'a:blinkon0' }
require('setup').keymap_table {
    { "<C-=>", ":lua vim.opt.linespace = math.min(vim.opt.linespace:get() + 1,  10)<CR>", 's' },
    { "<C-->", ":lua vim.opt.linespace = math.max(vim.opt.linespace:get() - 1,  0)<CR>",  's' },
}

if vim.g.neovide or vim.g.server_mode then
    vim.opt.guifont = os.getenv("NVIM_GUIFONT") or font.from_env()
    require('setup').global_table {
        neovide_fullscreen = false,
        neovide_remember_window_size = true,
        neovide_opacity = 1,
        neovide_floating_blur_amount_x = 2.0,
        neovide_floating_blur_amount_y = 2.0,
        neovide_hide_mouse_when_typing = true,
        neovide_underline_automatic_scaling = true,
        neovide_cursor_animate_command_line = true,
        neovide_cursor_animation_length = 0.15,
        neovide_cursor_smooth_blink = true,
        neovide_cursor_trail_size = 2.0,
        neovide_cursor_vfx_mode = {}, -- "sonicboom" -- "wireframe" -- "railgun"
        neovide_cursor_vfx_particle_lifetime = 1.2,
        neovide_cursor_vfx_particle_density = 1.0,
        neovide_cursor_vfx_particle_speed = 10.0,
        neovide_cursor_vfx_particle_phase = 5,
        neovide_cursor_vfx_particle_curl = 1.0,
    }


    vim.api.nvim_create_autocmd({ "UIEnter" }, {
        pattern = "*",
        callback = function()
            vim.opt.linespace = tonumber(os.getenv("NEOVIM_LINE_SPACE") or '0')
            vim.g.neovide_scale_factor = tonumber(os.getenv("NEOVIDE_SCALE_FACTOR") or '1.0')
            -- https://github.com/neovide/neovide/issues/1331
            if vim.g.loaded_clipboard_provider then
                vim.g.loaded_clipboard_provider = nil
                vim.api.nvim_cmd({ cmd = 'runtime', args = { 'autoload/provider/clipboard.vim' } }, {})
            end
        end
    })

    require('setup').keymap_table {
        { "<C-+>",   ":lua vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1,  1.0)<CR>", 's' },
        { "<C-_>",   ":lua vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1,  0.5)<CR>", 's' },
        { "<C-M-=>", ":lua vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + 0.05, 1.0)<CR>", 's' },
        { "<C-M-->", ":lua vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - 0.05, 0.0)<CR>", 's' },
    }
end

if vim.g.neovide then
    local function set_ime(args)
        if args.event:match("Enter$") then
            vim.g.neovide_input_ime = true
        else
            vim.g.neovide_input_ime = false
        end
    end

    local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "TermEnter", "TermLeave" }, {
        group = ime_input,
        pattern = "*",
        callback = set_ime
    })

    vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
        group = ime_input,
        pattern = "[/\\?]",
        callback = set_ime
    })
end


local neovide_focus = vim.api.nvim_create_augroup("NeovideFocusTracker", { clear = true })

vim.g.neovide_window_focused = 1

vim.api.nvim_create_autocmd("FocusLost", {
    group = neovide_focus,
    pattern = "*",
    callback = function() vim.g.neovide_window_focused = 0 end,
})

vim.api.nvim_create_autocmd("FocusGained", {
    group = neovide_focus,
    pattern = "*",
    callback = function() vim.g.neovide_window_focused = 1 end,
})
