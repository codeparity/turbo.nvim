local M = {}

-- Check if any LSP client is attached to the buffer
function M.has_lsp(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  return #clients > 0
end

-- Get list of attached LSP server names (e.g. "clangd", "pyright", "lua_ls", "vtsls")
function M.get_client_names(bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end
  return names
end

-- Safely run an LSP action with notification if no server is active
function M.run(action_fn, desc)
  if not M.has_lsp() then
    vim.notify(string.format("LSP '%s': No active language server attached to this file", desc or "action"), vim.log.levels.WARN)
    return
  end
  action_fn()
end

-- Standard Universal LSP Actions
function M.definition()
  M.run(function() vim.lsp.buf.definition() end, "Go to Definition")
end

function M.declaration()
  M.run(function() vim.lsp.buf.declaration() end, "Go to Declaration")
end

function M.references()
  M.run(function() vim.lsp.buf.references() end, "Find References")
end

function M.hover()
  M.run(function() vim.lsp.buf.hover() end, "Hover Documentation")
end

function M.signature_help()
  M.run(function() vim.lsp.buf.signature_help() end, "Signature Help")
end

function M.type_definition()
  M.run(function() vim.lsp.buf.type_definition() end, "Type Definition")
end

function M.implementation()
  M.run(function() vim.lsp.buf.implementation() end, "Go to Implementation")
end

function M.rename()
  M.run(function() vim.lsp.buf.rename() end, "Rename Symbol")
end

function M.code_action()
  M.run(function() vim.lsp.buf.code_action() end, "Code Action")
end

function M.format()
  M.run(function()
    vim.lsp.buf.format({ async = true })
    vim.notify("Document formatted via LSP", vim.log.levels.INFO)
  end, "Format Document")
end

function M.document_symbols()
  M.run(function() vim.lsp.buf.document_symbol() end, "Document Symbols")
end

function M.workspace_symbols()
  M.run(function()
    vim.ui.input({ prompt = "Workspace Symbol: " }, function(query)
      if query and #query > 0 then
        vim.lsp.buf.workspace_symbol(query)
      end
    end)
  end, "Workspace Symbols")
end

return M
