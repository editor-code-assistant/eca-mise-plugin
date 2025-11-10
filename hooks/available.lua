-- hooks/available.lua
function PLUGIN:Available(ctx)
    local helper = require("helper")
    local json = require("json")

    local resp, err = helper.github_request("https://api.github.com/repos/editor-code-assistant/eca/releases")
    if err then
        error("Failed to fetch releases: " .. err)
    end

    local releases = json.decode(resp.body)
    local result = {}
    for i, r in ipairs(releases) do
        local v = r.tag_name:gsub("^v", "")
        local note = r.prerelease and "Pre" or (i == 1 and "Latest" or nil)
        table.insert(result, {version = v, note = note})
    end
    return result
end
