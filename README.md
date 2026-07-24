# OpenResty on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/openresty?referralCode=ZqgrJ0)

A programmable OpenResty starter for Railway, built on a pinned official image. It includes a polished landing page, Lua JSON APIs, a health endpoint, structured access logs, security headers, and Railway-aware port handling.

## Included endpoints

| Endpoint | Purpose |
| --- | --- |
| `/` | Starter landing page that calls the Lua API from the browser. |
| `/health` | Lightweight Railway health check. |
| `/api/hello` | Lua-generated application metadata and request ID. |
| `/api/echo` | Echoes method, query parameters, content type, and request body. |

Try the echo endpoint:

```bash
curl -X POST 'https://your-domain.up.railway.app/api/echo?source=readme' \
  -H 'content-type: application/json' \
  -d '{"hello":"railway"}'
```

Request bodies are limited to 1 MiB by default.

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `PORT` | `8080` | OpenResty listen port and Railway public-domain target. |
| `APP_NAME` | `OpenResty on Railway` | Application name returned by `/api/hello`. |
| `GREETING` | `Hello from OpenResty` | Greeting returned by `/api/hello`. |

## Customize

- Add or change routes in [`openresty.conf.template`](openresty.conf.template).
- Put Lua handlers in [`lua/`](lua/).
- Replace the landing page in [`public/index.html`](public/index.html).
- Install OPM or LuaRocks packages in the Dockerfile. The pinned `bookworm-fat` image includes both package managers.

Environment variables read by Lua workers must also be declared in [`environment.main`](environment.main).

## Local development

```bash
docker build -t railway-openresty .
docker run --rm -p 8080:8080 -e PORT=8080 railway-openresty
```

Open <http://localhost:8080>.

## Security

The starter disables server-version tokens, sets baseline browser security headers, caps request bodies, and emits JSON access logs. Add authentication and application-specific controls before exposing sensitive routes.

## License

The starter configuration and sample application are MIT licensed. OpenResty and bundled dependencies retain their upstream licenses and trademarks.
