vim.g.config_root = debug.getinfo(1, 'S').source:match('^@(.+)/.+$')
vim.g.data_root   = os.getenv('HOME') .. '/.nvim'
vim.opt.runtimepath:prepend(vim.g.config_root)

require 'env'
require 'shim'
require 'common'

-- Check if config_root is writable (non-dev mode points to nix store, read-only)
local lazyhome = vim.uv.fs_access(vim.g.config_root, 'W')
    and (vim.g.config_root .. '/lazy')
    or (vim.g.data_root .. '/lazy')
local lazypath = lazyhome .. '/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('manifest', {
    root = lazyhome .. '/packages',
    readme = {
        root = lazyhome .. '/readme',
    },
    lockfile = lazyhome .. '/lazy-lock.json',
    change_detection = { enabled = false },
    rocks = {
        -- 使用系统 luarocks（NixOS 声明的 lua5_1 + luarocks），而非 hererocks 自建
        -- hererocks 自建环境在 NixOS 上缺 readline 头文件、CXX 编译器变量，容易构建失败
        hererocks = false,
    },
})

local user_config = os.getenv("HOME") .. '/.nvim.lua'
if vim.fn.empty(vim.fn.glob(user_config)) == 0 then
    vim.cmd('luafile ' .. user_config)
end
