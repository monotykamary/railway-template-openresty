local cjson = require "cjson.safe"

ngx.header.content_type = "application/json; charset=utf-8"
ngx.say(cjson.encode({
  application = os.getenv("APP_NAME") or "OpenResty on Railway",
  greeting = os.getenv("GREETING") or "Hello from OpenResty",
  requestId = ngx.var.request_id,
  runtime = "OpenResty",
  timestamp = ngx.utctime()
}))
