-- lib/helper.lua
local M = {}
function M.get_arch()
    local arch = RUNTIME.archType:lower()
    if arch == "amd64" then
        return "amd64"
    elseif arch == "arm64" then
        return "aarch64"
    else
        return arch
    end
end
function M.get_os()
    local os_l = RUNTIME.osType:lower()
    if os_l:find("windows") then
        return "windows"
    elseif os_l:find("darwin") then
        return "macos"
    elseif os_l:find("linux") then
        return "linux"
    else
        return os_l
    end
end
function M.get_platform()
    return M.get_os() .. "-" .. M.get_arch()
end
return M
