local asdf = require('asdf') -- Assuming access to asdf.nvim
-- local utils = require('asdf_lsp.utils')

local M = {}

-- function M.setup(options)
--   -- Setup or configuration steps
-- end

local function is_server_configured(server_name)
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.name == server_name then
      return true
    end
  end
  return false
end

function M.verify()
  local lspconfig = require('lspconfig')

  for server, _ in pairs(lspconfig) do
	if is_server_configured(server) then
	  local tools = asdf.tool_list(server)
		
	end
  end
end

return M
