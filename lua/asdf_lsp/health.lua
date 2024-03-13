local asdf = require('asdf')
local lspconfig = require('lspconfig')

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

local M = {}

function M.check()
  start("Checking LSP servers installation status")

  for server_name, config in pairs(lspconfig.configs) do
    if config.cmd then
      local cmd = config.cmd[1]
      local is_installed, version = asdf.tool_installed_version(cmd)

      if is_installed then
        ok(server_name .. " is installed. Version: " .. version)
      else
        error(server_name .. " is NOT installed.")
      end
    end
  end
end

function asdf.tool_installed_version(tool_name)
  local _, tools, exit_code = asdf.tool_list(tool_name)

  if exit_code == 0 and tools and #tools > 0 then
    for _, line in ipairs(tools) do
      if line:match("^%*") then
        local version = line:match("%*(%S+)")
        return true, version
      end
    end
  end

  return false, nil
end

return M

