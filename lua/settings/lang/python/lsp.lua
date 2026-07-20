local on_attach = function(client, bufnr)
  if client.name == 'ruff' then
    -- Disable hover in favor of ty
    client.server_capabilities.hoverProvider = false
  end
end

vim.lsp.config('ty', { on_attach = on_attach })
vim.lsp.enable('ty')

vim.lsp.config('ruff', { on_attach = on_attach })
vim.lsp.enable('ruff')
