-- hooks/pre_install.lua
function PLUGIN:PreInstall(ctx)
  local version = ctx.version
  local http = require("http")

  -- Determine platform using RUNTIME object
  local arch_token
  if RUNTIME.archType == "amd64" then
    arch_token = "amd64"
  elseif RUNTIME.archType == "arm64" then
    arch_token = "aarch64"
  else
    error("Unsupported architecture: " .. RUNTIME.archType)
  end

  local os_token
  if RUNTIME.osType == "Windows" then
    os_token = "windows"
  elseif RUNTIME.osType == "Darwin" then
    os_token = "macos"
  elseif RUNTIME.osType == "Linux" then
    os_token = "linux"
  else
    error("Unsupported operating system: " .. RUNTIME.osType)
  end

  -- Build filename based on platform
  local filename
  if os_token == "linux" then
    -- Use static build for better compatibility
    if arch_token == "amd64" then
      filename = "eca-native-static-linux-amd64.zip"
    else
      filename = "eca-native-linux-" .. arch_token .. ".zip"
    end
  else
    filename = "eca-native-" .. os_token .. "-" .. arch_token .. ".zip"
  end

  -- Build download URL
  local url = "https://github.com/editor-code-assistant/eca/releases/download/v" .. version .. "/" .. filename

  -- Fetch SHA256 checksum
  local sha256 = nil
  local checksum_url = url .. ".sha256"
  local checksum_resp, checksum_err = http.get({ url = checksum_url })

  if checksum_err == nil and checksum_resp.status_code == 200 then
    -- Extract SHA256 from checksum file
    sha256 = checksum_resp.body:match("^(%w+)")
  end

  return {
    version = version,
    url = url,
    sha256 = sha256,
    note = "Installing ECA " .. version .. " (" .. os_token .. "-" .. arch_token .. ")"
  }
end
