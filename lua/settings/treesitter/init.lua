if not vim.g.has_git then
    return
end

-- ── 编译器检测 ──────────────────────────────────────
if os.getenv('NVIM_MUSL') == '1' then
    vim.env.CC = "musl-gcc"
end

local compilers = { "cc", "gcc", "clang", "cl", "zig" }
local has_cc = false
for _, cc in ipairs(compilers) do
    if vim.fn.executable(cc) == 1 then
        has_cc = true
        break
    end
end

-- ── tree-sitter-manager setup ───────────────────────
local tsm = require('tree-sitter-manager')
tsm.setup({
    -- norg/norg_meta 由 nvim-neorg 项目自维护，不在 tsm 内置 registry 里，需手动注册
    languages = {
        norg = {
            install_info = {
                url = "https://github.com/nvim-neorg/tree-sitter-norg",
                location = "src",
                revision = "d89d95af13d409f30a6c7676387bde311ec4a2c8", -- v0.2.6
            },
        },
        norg_meta = {
            install_info = {
                url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
                location = "src",
                revision = "6f0510cc516a3af3396a682fbd6655486c2c9d2d", -- v0.1.0
            },
        },
    },
    ensure_installed = {
        "norg",
        "norg_meta",
        "css",
        "diff",
        "dockerfile",
        "go",
        "gomod",
        "haskell",
        "html",
        "javascript",
        "jsdoc",
        "json",
        -- lua, markdown, markdown_inline: Neovim 0.12 内置
        "nu",
        "python",
        "regex",
        "rust",
        "sql",
        "toml",
        "typescript",
        "vue",
        "yaml",
    },
    highlight = true,
})
