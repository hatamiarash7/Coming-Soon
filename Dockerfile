FROM nginx:1.24.0-alpine

ARG DATE_CREATED
ARG APP_VERSION

LABEL maintainer="Arash Hatami <hatamiarash7@gmail.com>"
LABEL org.opencontainers.image.created=$DATE_CREATED
LABEL org.opencontainers.image.version=$DATE_CREATED
LABEL org.opencontainers.image.authors="hatamiarash7"
LABEL org.opencontainers.image.vendor="hatamiarash7"
LABEL org.opencontainers.image.title="Coming Soon"
LABEL org.opencontainers.image.description="Coming soon template"
LABEL org.opencontainers.image.source="https://github.com/hatamiarash7/coming-soon"

RUN rm /etc/nginx/nginx.conf

COPY ./src/* /usr/share/nginx/html/
COPY ./config/nginx.conf.template /etc/nginx/

EXPOSE 81

CMD ["/bin/sh", "-c", "envsubst '$${PAGE_TITLE}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && echo 'Server is running...' && nginx -g 'daemon off;'"]
