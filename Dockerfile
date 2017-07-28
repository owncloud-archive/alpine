FROM alpine:edge
MAINTAINER ownCloud DevOps <devops@owncloud.com>

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
    su-exec && \
  rm -rf /var/cache/apk/*

LABEL org.label-schema.version=latest
LABEL org.label-schema.vcs-url="https://github.com/owncloud-docker/alpine.git"
LABEL org.label-schema.name="ownCloud Alpine"
LABEL org.label-schema.vendor="ownCloud GmbH"
LABEL org.label-schema.schema-version="1.0"
