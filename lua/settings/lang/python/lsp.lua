local on_attach = function(client, bufnr)
  if client.name == 'ruff' then
    -- Disable hover in favor of Pyrefly
    client.server_capabilities.hoverProvider = false
  end
end

-- Detect venv: check .venv, venv, then $VIRTUAL_ENV
local function detect_venv_python()
  local cwd = vim.fn.getcwd()
  for _, name in ipairs({ '.venv', 'venv' }) do
    local p = cwd .. '/' .. name .. '/bin/python3'
    if vim.fn.executable(p) == 1 then
      return p
    end
  end
  local venv = os.getenv('VIRTUAL_ENV')
  if venv and vim.fn.executable(venv .. '/bin/python3') == 1 then
    return venv .. '/bin/python3'
  end
  return nil
end

-- Pyrefly: auto-detect venv for type checking
local pyrefly_settings = {}
local venv_python = detect_venv_python()
if venv_python then
  pyrefly_settings = {
    pythonInterpreterPath = venv_python,
  }
end

vim.lsp.config('pyrefly', {
  on_attach = on_attach,
  settings = pyrefly_settings,
})
vim.lsp.enable('pyrefly')

vim.lsp.config('ruff', { on_attach = on_attach })
vim.lsp.enable('ruff')
