-- kong/plugins/AUTH-INJECTOR/schema.lua
return {
  name = "auth-injector",
  fields = {
    { config = {
        type   = "record",
        fields = {
          { auth_service_url = {
              type     = "string",
              required = true,
          }},
        },
    }},
  },
}