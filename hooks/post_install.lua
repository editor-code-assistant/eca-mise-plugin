-- hooks/post_install.lua
function PLUGIN:PostInstall(ctx)
    local helper = require("helper")
    local tool = helper.get_tool()

    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    if not sdkInfo then
        for _, info in pairs(ctx.sdkInfo) do
            sdkInfo = info
            break
        end
    end
    local path = sdkInfo.path

    local is_windows = RUNTIME.osType:lower():find("windows")
    local bin = path .. "/" .. tool.bin .. (is_windows and ".exe" or "")

    -- Set executable permissions on Unix
    if not is_windows then
        if os.execute(string.format("chmod +x '%s'", bin)) ~= 0 then
            error("Failed to set executable permissions")
        end
    end

    -- Verify binary
    local null = is_windows and "NUL" or "/dev/null"
    if os.execute("\"" .. bin .. "\"" .. tool.version_check .. " > " .. null .. " 2>&1") ~= 0 then
        error(tool.name .. " binary verification failed")
    end
end
