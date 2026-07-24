local cjson = require "cjson.safe"

ngx.req.read_body()
local body = ngx.req.get_body_data()
local headers = ngx.req.get_headers()

ngx.header.content_type = "application/json; charset=utf-8"
ngx.say(cjson.encode({
  method = ngx.req.get_method(),
  path = ngx.var.uri,
  query = ngx.req.get_uri_args(),
  body = body,
  contentType = headers["content-type"],
  requestId = ngx.var.request_id
}))
