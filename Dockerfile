FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE="2022-03-02"
ARG VERSION="4.4.1"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

# environment settings
ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

# install runtime packages and qbitorrent-cli
RUN \
  apk add -U --update --no-cache \
    bash \
    curl \
    python3

# add local files
COPY root/ /
COPY qbittorrent-nox /usr/bin

# ports and volumes
EXPOSE 8989 6881 6881/udp

VOLUME /config
