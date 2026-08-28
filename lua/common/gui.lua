-- PR_SET_PDEATHSIG: 让 neovide 拉起的 nvim 在其直接父进程(neovide)死亡时自动收到
-- SIGTERM，从内核层面根治「UI 窗口关了但 nvim 永久无头存活、持续吃内存」的泄漏。
-- 用 NEOVIDE_FRAME 判定(exec 时即置位, 比 vim.g.neovide 更早可靠), 不误伤 zellij/终端 nvim。
-- getppid 竞态保护: 父进程已死(被 init 收养, ppid=1)时不再武装, 避免误设。
do
  if os.getenv("NEOVIDE_FRAME") then
    pcall(function()
      local ok, ffi = pcall(require, "ffi")
      if not ok then return end
      ffi.cdef([[
        int getppid(void);
        int prctl(int option, unsigned long arg2, unsigned long arg3,
                  unsigned long arg4, unsigned long arg5);
      ]])
      if ffi.C.getppid() ~= 1 then
        ffi.C.prctl(1, 15, 0, 0, 0) -- PR_SET_PDEATHSIG=1 + SIGTERM=15
      end
    end)
  end
end

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
        neovide_refresh_rate = 30,  -- Cap render FPS when VSync is ignored on Wayland (idle spin prevention, paired with config vsync=false)
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
        -- Core guard: skip entirely until Neovide's UI has fully attached, to avoid a startup deadlock
        if vim.g.neovide and not vim.g.neovide_channel_id then
            return
        end

        if args.event:match("Enter$") then
            if args.event:match("^Cmdline") then
                -- Safely wrap getcmdtype: it can error during very early startup
                local ok, cmd_type = pcall(vim.fn.getcmdtype)
                if ok and (cmd_type == "/" or cmd_type == "?") then
                    vim.g.neovide_input_ime = true
                else
                    vim.g.neovide_input_ime = false
                end
            elseif args.event == "TermEnter" then
                -- 终端模式：进入打开输入法
                vim.g.neovide_input_ime = true
            else
                vim.g.neovide_input_ime = true   -- InsertEnter：中文可用
            end
        else
            vim.g.neovide_input_ime = false      -- InsertLeave/TermLeave/CmdlineLeave：全部英文
        end
    end

    local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

    vim.api.nvim_create_autocmd({
        "InsertEnter", "InsertLeave",
        "TermEnter", "TermLeave",
        "CmdlineEnter", "CmdlineLeave"
    }, {
        group = ime_input,
        pattern = "*",
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
