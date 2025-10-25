local M = {}

--- Salvar e formatar
function M.save_and_format()
  if vim.lsp.get_clients() then
    vim.lsp.buf.format({ async = false })
  end
  vim.cmd("write")
end

--- Salvar sem formatar
function M.save_without_format()
  vim.cmd("noautocmd write")
end

return M
