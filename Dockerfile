FROM openresty/openresty:1.31.8.1-0-bookworm-fat@sha256:42a8ac49fafd9c0aa2e64a14f628c784f75f84dda5bffdadc2b3e45563c5e83b

COPY openresty.conf.template /etc/nginx/templates/default.conf.template
COPY environment.main /etc/nginx/conf.d/environment.main
COPY start-openresty.sh /usr/local/bin/start-openresty
COPY lua/ /app/lua/
COPY public/ /app/public/

RUN chmod 0555 /usr/local/bin/start-openresty

ENV PORT=8080
ENV APP_NAME="OpenResty on Railway"
ENV GREETING="Hello from OpenResty"

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/start-openresty"]
