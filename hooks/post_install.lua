-- hooks/post_install.lua
function PLUGIN:PostInstall(ctx)
  local sdkInfo = ctx.sdkInfo['eca']
  local path = sdkInfo.path

  -- Set executable permissions on Unix systems
  if RUNTIME.osType ~= "Windows" then
    local result = os.execute("chmod +x " .. path .. "/eca")
    if result ~= 0 then
      error("Failed to set executable permissions on eca binary")
    end
  end

  -- Verify installation by checking if binary exists and is executable
  local binary_path
  if RUNTIME.osType == "Windows" then
    binary_path = path .. "/eca.exe"
  else
    binary_path = path .. "/eca"
  end

  -- Test that the binary works
  local test_cmd = binary_path .. " --version"
  local test_result = os.execute(test_cmd .. " > /dev/null 2>&1")
  if test_result ~= 0 then
    error("ECA binary installation verification failed")
  end
end
