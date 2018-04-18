FROM alpine:3.6

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>" \
  org.label-schema.name="ownCloud Alpine" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

ENV TERM xterm

ADD rootfs /
CMD ["bash"]

RUN apk update && \
  apk upgrade && \
  apk add \
    ca-certificates \
    bash \
    vim \
    curl \
    wget \
    bzip2 \
    unzip \
    ncurses \
    tar \
    shadow \
    su-exec \
    git && \
  rm -rf /var/cache/apk/*
