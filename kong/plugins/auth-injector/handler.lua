-- kong/plugins/AUTH-INJECTOR/handler.lua
local http  = require "resty.http"
local cjson = require "cjson"

local AuthInjector = {}
AuthInjector.PRIORITY = 1000
AuthInjector.VERSION  = "1.0.0"

function AuthInjector:access(conf)
  local auth_header = kong.request.get_header("Authorization")

  if not auth_header or not auth_header:find("^Bearer ") then
    return kong.response.exit(401, cjson.encode({ error = "Missing or invalid Authorization header" }))
  end

  local httpc = http.new()
  local res, err = httpc:request_uri(conf.auth_service_url, {  -- ✅ from kong.yml config
    method  = "GET",
    headers = {
      ["Authorization"] = auth_header,
      ["Content-Type"]  = "application/json",
    },
  })

  if err or not res then
    return kong.response.exit(502, cjson.encode({ error = "Auth service unreachable" }))
  end

  if res.status ~= 200 then
    return kong.response.exit(401, cjson.encode({ error = "Unauthorized" }))
  end

  local ok, body = pcall(cjson.decode, res.body)
  if not ok or not body or not body.userId then
    return kong.response.exit(500, cjson.encode({ error = "Invalid auth service response" }))
  end

  kong.service.request.set_header("X-User-Id", tostring(body.userId))
end

return AuthInjector