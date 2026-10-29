-- hooks/available.lua
function PLUGIN:Available(ctx)
    local helper = require("helper")
    local json = require("json")
    local tool = helper.get_tool()

    local resp, err = helper.github_request("https://api.github.com/repos/" .. tool.repo .. "/releases?per_page=100")
    if err then
        error("Failed to fetch releases: " .. err)
    end

    local releases = json.decode(resp.body)
    local result = {}
    for i, r in ipairs(releases) do
        local v = r.tag_name:gsub("^v", "")
        local note = r.prerelease and "Pre" or (i == 1 and "Latest" or nil)
        table.insert(result, {version = v, note = note, created_at = r.published_at or r.created_at})
    end
    return result
end
