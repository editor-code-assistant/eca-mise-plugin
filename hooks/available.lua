-- hooks/available.lua
function PLUGIN:Available(ctx)
  local http = require("http")
  local json = require("json")

  -- Fetch releases from GitHub API
  local resp, err = http.get({
    url = "https://api.github.com/repos/editor-code-assistant/eca/releases"
  })

  if err ~= nil then
    error("Failed to fetch releases from GitHub API: " .. err)
  end

  if resp.status_code ~= 200 then
    error("GitHub API returned status " .. resp.status_code .. ": " .. resp.body)
  end

  local releases = json.decode(resp.body)
  local result = {}

  for i, release in ipairs(releases) do
    local version = release.tag_name
    -- Remove 'v' prefix if present
    version = version:gsub("^v", "")

    local note = nil
    if release.prerelease then
      note = "Pre-release"
    elseif i == 1 then
      note = "Latest"
    end

    table.insert(result, {
      version = version,
      note = note
    })
  end

  return result
end
