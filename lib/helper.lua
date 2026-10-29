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

-- Tool definitions. The plugin serves both tools; which one is decided by the
-- name the plugin was installed under (e.g. `mise plugin install eca-cli <url>`).
M.TOOLS = {
    ["eca"] = {
        name = "eca",
        repo = "editor-code-assistant/eca",
        bin = "eca",
        asset = function(os_token, arch_token)
            return string.format("eca-native-%s-%s.zip", os_token, arch_token)
        end,
        version_check = " --version"
    },
    ["eca-cli"] = {
        name = "eca-cli",
        repo = "editor-code-assistant/eca-cli",
        bin = "eca-cli",
        asset = function(os_token, arch_token)
            if os_token == "windows" then
                error("eca-cli has no native Windows binary; use `bb eca-cli.jar` instead")
            end
            return string.format("eca-cli-%s-%s.tar.gz", os_token, arch_token)
        end,
        version_check = " --version"
    }
}

-- Determine which tool this plugin instance manages, from the plugin
-- directory name (i.e. the name passed to `mise plugin install`).
function M.get_tool()
    local dir = (RUNTIME and RUNTIME.pluginDirPath) or ""
    local base = (dir:gsub("[/\\]+$", "")):match("([^/\\]+)$") or ""
    if base:lower():find("eca%-cli") or base:lower():find("eca_cli") then
        return M.TOOLS["eca-cli"]
    end
    return M.TOOLS["eca"]
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

    -- Invalid/expired token: retry unauthenticated (public repos don't need auth)
    if resp.status_code == 401 and token then
        headers["Authorization"] = nil
        token = nil
        resp, err = http.get({url = url, headers = headers})
        if err then
            return nil, "HTTP request failed: " .. err
        end
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
