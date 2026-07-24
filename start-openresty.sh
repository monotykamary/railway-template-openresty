#!/bin/sh
set -eu

port="${PORT:-8080}"
case "$port" in
  ''|*[!0-9]*)
    echo "PORT must be an integer between 1 and 65535" >&2
    exit 1
    ;;
esac
if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
  echo "PORT must be an integer between 1 and 65535" >&2
  exit 1
fi

sed "s/__PORT__/$port/g" \
  /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec /usr/local/openresty/bin/openresty -g 'daemon off;'
