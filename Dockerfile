FROM nginx:1.30.0-alpine

ENV NGINX_USER=nginx
ARG DATE_CREATED
ARG APP_VERSION

LABEL maintainer="Arash Hatami <hatamiarash7@gmail.com>"
LABEL org.opencontainers.image.created=$DATE_CREATED
LABEL org.opencontainers.image.version=$APP_VERSION
LABEL org.opencontainers.image.authors="hatamiarash7"
LABEL org.opencontainers.image.vendor="hatamiarash7"
LABEL org.opencontainers.image.title="Coming Soon"
LABEL org.opencontainers.image.description="Coming soon template"
LABEL org.opencontainers.image.source="https://github.com/hatamiarash7/coming-soon"

# Copy static files and set permissions
COPY ./src/ /usr/share/nginx/html/
COPY ./config/default.conf.template /etc/nginx/templates/default.conf.template

# Fix permissions for Nginx directories before switching user
RUN mkdir -p /run/nginx \
    && chown -R ${NGINX_USER}:${NGINX_USER} /usr/share/nginx/html \
    && chown -R ${NGINX_USER}:${NGINX_USER} /etc/nginx/templates \
    && chown -R ${NGINX_USER}:${NGINX_USER} /etc/nginx/conf.d \
    && chown -R ${NGINX_USER}:${NGINX_USER} /var/cache/nginx \
    && chown -R ${NGINX_USER}:${NGINX_USER} /run/nginx \
    && chmod -R 755 /usr/share/nginx/html /etc/nginx/templates /etc/nginx/conf.d /var/cache/nginx /run/nginx

# Healthcheck for Nginx (uses NGINX_PORT env, defaults to 80)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --spider http://127.0.0.1:${NGINX_PORT:-80}/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
