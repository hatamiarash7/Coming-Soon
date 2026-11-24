FROM nginx:1.31.10-alpine@sha256:aceb952b920393b7d0bc7b978927fc283370bea89fb082c6fef0ce18c60f96a9

LABEL org.opencontainers.image.title="Coming Soon" \
    org.opencontainers.image.description="A self-contained pre-launch landing page served by Nginx" \
    org.opencontainers.image.authors="Arash Hatami <hatamiarash7@gmail.com>" \
    org.opencontainers.image.source="https://github.com/hatamiarash7/coming-soon" \
    org.opencontainers.image.licenses="MIT"

ENV NGINX_PORT=8080 \
    PAGE_TITLE="Coming Soon" \
    NGINX_ENVSUBST_OUTPUT_DIR=/tmp \
    NGINX_ENVSUBST_FILTER="^(NGINX_PORT|ESCAPED_TITLE)$"

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf.template /etc/nginx/templates/default.conf.template
COPY --chmod=755 config/15-page.envsh /docker-entrypoint.d/15-page.envsh
COPY src/ /srv/coming-soon/

USER 101:101
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["sh", "-c", "exec wget -Y off -q --spider \"http://127.0.0.1:${NGINX_PORT}/\""]
