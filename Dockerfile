FROM openresty/openresty:1.31.1.1-3-bookworm-fat@sha256:59eaa54c12021e799adbea1bc3acdf4097f9cac105f889e417d017deb263a755

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
