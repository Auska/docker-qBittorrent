FROM alpine:3.13 as compilingqB

#compiling qB

ENV QT=4.3.6.10

RUN apk add --no-cache wget curl bash unzip \
&& mkdir /qbtorrent \
&& cd /qbtorrent \
&& wget https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-${QT}/qbittorrent-nox_x86_64-linux-musl_static.zip \
&& unzip qbittorrent-nox_x86_64-linux-musl_static.zip
 

# docker qB

FROM lsiobase/alpine:3.13

# set version label
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai WEBUIPORT=8989 PGID=1000 PUID=1000 UMASKSET=022 FIX=YES

# copy local files
COPY root /
COPY --from=compilingqB /qbtorrent/qbittorrent-nox /usr/local/bin/qbittorrent-nox

RUN \
	echo "**** install packages ****" \
#	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk add --no-cache bash ca-certificates tzdata python3 \
	&& rm -rf /var/cache/apk/* \
	&& chmod a+x /usr/local/bin/qbittorrent-nox 

# ports and volumes
VOLUME /media /config
EXPOSE 8989 8999 8999/udp
ENTRYPOINT [ "/init" ]