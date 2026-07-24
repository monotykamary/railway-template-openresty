local cjson = require "cjson.safe"

ngx.status = ngx.HTTP_NOT_FOUND
ngx.header.content_type = "application/json; charset=utf-8"
ngx.say(cjson.encode({
  error = "not_found",
  path = ngx.var.uri,
  requestId = ngx.var.request_id
}))
