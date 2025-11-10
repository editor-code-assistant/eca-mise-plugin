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

-- Make authenticated GitHub API request
function M.github_request(url)
    local http = require("http")
    local headers = {}

    -- Try to get GitHub token from environment
    local token = os.getenv("GITHUB_TOKEN") or os.getenv("GITHUB_API_TOKEN") or os.getenv("GH_TOKEN")
    if token then
        headers["Authorization"] = "Bearer " .. token
    end

    -- Set User-Agent (required by GitHub API)
    headers["User-Agent"] = "mise-vfox-eca-plugin"

    local resp, err = http.get({
        url = url,
        headers = headers
    })

    if err then
        return nil, "HTTP request failed: " .. err
    end

    if resp.status_code == 403 then
        local err_msg = "GitHub API rate limit exceeded. "
        if not token then
            err_msg = err_msg .. "Please set GITHUB_TOKEN environment variable to authenticate and increase rate limit."
        else
            err_msg = err_msg .. "Authenticated request failed with 403."
        end
        return nil, err_msg
    end

    if resp.status_code ~= 200 then
        return nil, "GitHub API returned status code: " .. resp.status_code
    end

    return resp, nil
end

return M
