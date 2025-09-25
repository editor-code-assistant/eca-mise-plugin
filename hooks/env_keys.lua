-- hooks/env_keys.lua
function PLUGIN:EnvKeys(ctx)
    return {{key = "PATH", value = ctx.path}}
end
