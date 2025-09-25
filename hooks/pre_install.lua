-- hooks/pre_install.lua
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local http = require("http")

    -- Normalize architecture
    local arch = RUNTIME.archType:lower()
    local arch_token
    if arch == "amd64" or arch == "x86_64" then
        arch_token = "amd64"
    elseif arch == "arm64" or arch == "aarch64" then
        arch_token = "aarch64"
    else
        error("Unsupported architecture: " .. RUNTIME.archType)
    end

    -- Normalize OS
    local os_l = RUNTIME.osType:lower()
    local os_token
    if os_l:find("windows") then
        os_token = "windows"
    elseif os_l:find("darwin") then
        os_token = "macos"
    elseif os_l:find("linux") then
        os_token = "linux"
    else
        error("Unsupported OS: " .. RUNTIME.osType)
    end

    -- Construct filename (dynamic builds)
    local filename = string.format("eca-native-%s-%s.zip", os_token, arch_token)
    local url = string.format("https://github.com/editor-code-assistant/eca/releases/download/%s/%s", version, filename)

    -- Fetch checksum
    local sha256
    do
        local resp, err = http.get({url = url .. ".sha256"})
        if not err and resp.status_code == 200 then
            sha256 = resp.body:match("^(%w+)")
        end
    end

    return {version = version, url = url, sha256 = sha256, note = "Installing ECA " .. version}
end
