FROM nginx:1.24.0-alpine

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

COPY ./src/* /usr/share/nginx/html/
COPY ./config/default.conf.template /etc/nginx/templates/default.conf.template

CMD ["nginx", "-g", "daemon off;"]
