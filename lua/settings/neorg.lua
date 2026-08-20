-- 1. 定义外部 JSON 路径（方案二）
local json_path = vim.fn.expand("~/.config/neorg/workspaces.json")
local workspaces = {
    notes = "~/notes", -- 兜底默认值
}

-- 2. 解析 JSON 文件中的静态工作区
if vim.fn.filereadable(json_path) == 1 then
    local file = io.open(json_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        local ok, parsed = pcall(vim.json.decode, content)
        if ok then workspaces = parsed end
    end
end

-- 3. 动态获取当前终端的绝对路径（方案三）
local cwd = vim.fn.getcwd()
local current_dir_name = vim.fn.fnamemodify(cwd, ":t")

-- 4. 强制将当前项目目录注入到工作区列表中
workspaces["current"] = cwd

-- 5. 如果当前目录包含 .norg 文件，单独注册一个以项目名命名的具名工作区
if #vim.fn.globpath(cwd, "*.norg") > 0 then
    workspaces[current_dir_name] = cwd
end

-- 6. 初始化 Neorg
require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
            }
        },
        ["core.dirman"] = {
            config = {
                workspaces = workspaces,
                default_workspace = "notes",
                autodetect_workspaces = false,
            },
        },
    },
})
