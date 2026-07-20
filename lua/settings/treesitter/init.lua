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
    ensure_installed = {
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
