FROM kong:3.6

# Switch to root to copy files with correct permissions
USER root

# Environment variables
ENV KONG_DATABASE="off" \
    KONG_DECLARATIVE_CONFIG=/kong/config/kong-config.yml \
    KONG_PROXY_ACCESS_LOG=/dev/stdout \
    KONG_ADMIN_ACCESS_LOG=/dev/stdout \
    KONG_PROXY_ERROR_LOG=/dev/stderr \
    KONG_ADMIN_ERROR_LOG=/dev/stderr \
    KONG_PROXY_LISTEN="0.0.0.0:8000, 0.0.0.0:8443 ssl" \
    KONG_ADMIN_LISTEN="0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    KONG_LOG_LEVEL=debug \
    KONG_PLUGINS=bundled,auth-injector \
    KONG_LUA_PACKAGE_PATH="/usr/local/custom-plugins/?.lua;;" \
    KONG_NGINX_WORKER_PROCESSES="1" \
    KONG_NGINX_USER="kong kong" \
    KONG_NGINX_DAEMON="off"

# Copy declarative config
COPY config/kong-config.yml /kong/config/kong-config.yml

# Copy custom plugin — path matches KONG_LUA_PACKAGE_PATH above
COPY plugins/auth-injector /usr/local/custom-plugins/kong/plugins/auth-injector

# Fix ownership so Kong (runs as kong user) can read the files
RUN chown -R kong:kong /kong/config /usr/local/custom-plugins

USER kong

EXPOSE 8000 8443 8001 8444
