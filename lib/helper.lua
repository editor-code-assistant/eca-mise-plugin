-- lib/helper.lua
local M = {}

function M.get_arch()
  local arch = RUNTIME.archType
  if arch == "amd64" then
    return "amd64"
  elseif arch == "arm64" then
    return "aarch64"
  else
    return arch
  end
end

function M.get_os()
  local os = RUNTIME.osType
  if os == "Windows" then
    return "windows"
  elseif os == "Darwin" then
    return "macos"
  else
    return "linux"
  end
end

function M.get_platform()
  return M.get_os() .. "-" .. M.get_arch()
end

return M
