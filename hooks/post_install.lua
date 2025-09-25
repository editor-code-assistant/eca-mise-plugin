-- hooks/post_install.lua
function PLUGIN:PostInstall(ctx)
    local sdkInfo = ctx.sdkInfo["eca"]
    local path = sdkInfo.path

    -- Set executable permissions on Unix
    local os_lower = RUNTIME.osType:lower()
    if not os_lower:find("windows") then
        local cmd = string.format("chmod +x %s/eca", path)
        if os.execute(cmd) ~= 0 then
            error("Failed to set executable permissions")
        end
    end

    -- Verify binary
    local bin = os_lower:find("windows") and (path .. "/eca.exe") or (path .. "/eca")
    if os.execute(bin .. " --version > /dev/null 2>&1") ~= 0 then
        error("ECA binary verification failed")
    end
end
