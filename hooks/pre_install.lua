-- hooks/pre_install.lua
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local helper = require("helper")
    local tool = helper.get_tool()

    -- Get normalized OS and architecture
    local os_token = helper.get_os()
    local arch_token = helper.get_arch()

    local filename = tool.asset(os_token, arch_token)
    local url = string.format("https://github.com/%s/releases/download/%s/%s", tool.repo, version, filename)

    -- Fetch checksum
    local sha256
    do
        local resp, err = helper.github_request(url .. ".sha256")
        if not err and resp then
            sha256 = resp.body:match("^(%x+)")
        end
    end

    return {version = version, url = url, sha256 = sha256, note = "Installing " .. tool.name .. " " .. version}
end
