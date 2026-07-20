local M = {}
--[[
#/usr/share/applications/neovide.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Exec=bash -c 'export NVIM_LEVEL=x SHELL=/usr/local/bin/nu; export PATH=/opt/node/bin:$HOME/.local/bin:$PATH; /usr/local/bin/neovide --maximized'
Name=Neovide
Icon=nvim
Categories=Utility;TextEditor;
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
--]]


local fonts_abbr = {
    Lilex = "Lilex",
    JetBrainsMono = "JetBrainsMono Nerd Font Mono",
    Argon = "Monaspace Argon Light",
    Xenon = "Monaspace Xenon Light",
    Neon = "Monaspace Neon Light",
    Krypton = "Monaspace Krypton Light",
    Radon = "Monaspace Radon Light",
}


function M.parse(f)
    local opt = string.gmatch(f, '(%a+)(%d*)(%a*)')
    local n, s, o = opt()
    if s ~= '' then
        vim.g.select_font_size = s
    end
    M.name = fonts_abbr[n] or n
    M.size = vim.g.select_font_size
    M.opt = o
    if vim.g.neovide then
        vim.g.neovide_font_features = { "Lilex: -calt, +liga, +ss01, +ss02" }
    end
    return M
end

function M:guifont()
    local en
    if vim.g.neovide then
        en = self.name
    else
        en = self.name .. ":h" .. self.size .. self.opt
    end

    local zh = "Noto Sans Mono CJK SC" .. ":h" .. self.size
    return en .. ',' .. zh
end

function M.parse_env()
    local default_font = 'Lilex11'
    return M.parse(os.getenv("NVIM_FONT") or default_font)
end

function M.from_env()
    return M.parse_env():guifont()
end


vim.g.select_font_size = 11
vim.api.nvim_create_user_command('SelectFont',
    function(ctx)
        local font = M.parse(ctx.args):guifont()
        print("select font: " .. font)
        vim.opt.guifont = font
    end,
    {
        nargs = '?',
        complete = function()
            local ks = {}
            for k, _ in pairs(fonts_abbr) do
                table.insert(ks, k)
            end
            return ks
        end
    }
)

return M
