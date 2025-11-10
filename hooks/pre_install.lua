-- hooks/pre_install.lua
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local helper = require("helper")

    -- Get normalized OS and architecture
    local os_token = helper.get_os()
    local arch_token = helper.get_arch()

    -- Construct filename (dynamic builds)
    local filename = string.format("eca-native-%s-%s.zip", os_token, arch_token)
    local url = string.format("https://github.com/editor-code-assistant/eca/releases/download/%s/%s", version, filename)

    -- Fetch checksum
    local sha256
    do
        local resp, err = helper.github_request(url .. ".sha256")
        if not err and resp then
            sha256 = resp.body:match("^(%w+)")
        end
    end

    return {version = version, url = url, sha256 = sha256, note = "Installing ECA " .. version}
end
