local asdf = require('asdf')
local lspconfig = require('lspconfig')

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local M = {}

local function tool_installed_version(tool_name)
  local _, tools, exit_code = asdf.tool_list(tool_name)
  print("tools: ", vim.inspect(tools))
  print("exit_code: ", exit_code)

  if exit_code == 0 and tools and #tools > 0 then
    for _, line in ipairs(tools) do
	  if line:match("^%s*%*") then
		local version = line:match("%*%s*(%S+)")
		return true, version
	  end
    end
  end

  return false, nil
end

function M.check()
  start("Checking LSP servers installation status")

  local servers = require('lspconfig.util').available_servers()

  for _, server in ipairs(servers) do
	local config = lspconfig[server] -- Access to trigger __index if not already loaded
	if config and not vim.tbl_isempty(config) then
	  print("Loaded configuration for: ", server)
	  if config.cmd then
		local cmd_path = config.cmd[1]
		print("cmd_path: ", cmd_path)

		local cmd = cmd_path:match("([^/]+)$")
		print("cmd: ", cmd)

		local is_installed, version = tool_installed_version(cmd)

		if is_installed then
		  ok(server .. " active_version: " .. version)
		else
		  error(server .. " not found.")
		end
	  end
	else
	  print("No configuration for:", server)
	end

  end
end


return M

