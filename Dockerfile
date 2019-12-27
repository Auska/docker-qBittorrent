FROM alpine:3.11 as compilingqB

#compiling qB

ARG  LIBTORRENT_VER=1.2.3
ARG  QBITTORRENT_VER=4.2.1.10


RUN  apk add --no-cache ca-certificates make g++ gcc qt5-qtsvg-dev boost-dev qt5-qttools-dev file \
&&   mkdir /qbtorrent  \
&&   wget -P /qbtorrent https://github.com/arvidn/libtorrent/releases/download/libtorrent-`echo "$LIBTORRENT_VER"|sed 's#\.#_#g'`/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz   \
&&   tar  -zxvf  /qbtorrent/libtorrent-rasterbar-${LIBTORRENT_VER}.tar.gz   -C    /qbtorrent  \
&&   cd  /qbtorrent/libtorrent-rasterbar-${LIBTORRENT_VER} \
&&   ./configure  --host=x86_64-alpine-linux-musl \
&&   make install-strip \
#qBittorrent
#&&   wget  -P /qbtorrent  https://github.com/qbittorrent/qBittorrent/archive/release-${QBITTORRENT_VER}.zip  \
#&&   unzip   /qbtorrent/release-${QBITTORRENT_VER}.zip  -d    /qbtorrent \
#&&   cd  /qbtorrent/qBittorrent-release-${QBITTORRENT_VER} \
#qBittorrent-Enhanced-Edition
&&   wget  -P /qbtorrent https://github.com/c0re100/qBittorrent-Enhanced-Edition/archive/release-${QBITTORRENT_VER}.zip   \
&&   unzip   /qbtorrent/release-${QBITTORRENT_VER}.zip  -d    /qbtorrent \
&&   cd  /qbtorrent/qBittorrent-Enhanced-Edition-release-${QBITTORRENT_VER} \
&&   sed -i -e 's|qBittorrent Enhanced|qBittorrent|g' -e 's|if (!torrent->isPrivate()) ||g' src/base/bittorrent/session.cpp \
&&   sed -i -e 's|VER_BUILD = 10|VER_BUILD = 0|g' version.pri \
&&   ./configure   --disable-gui --host=x86_64-alpine-linux-musl \
&&   make install \
&&   ldd /usr/local/bin/qbittorrent-nox   |cut -d ">" -f 2|grep lib|cut -d "(" -f 1|xargs tar -chvf /qbtorrent/qbittorrent.tar  \
&&   mkdir /qbittorrent   \
&&   tar  -xvf /qbtorrent/qbittorrent.tar   -C  /qbittorrent   \
&&   cp --parents /usr/local/bin/qbittorrent-nox  /qbittorrent
 

# docker qB

FROM lsiobase/alpine:3.11

# set version label
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin TRACKERSAUTO=Yes WEBUIPORT=8989 PGID=0 PUID=0 FIX=YES

# copy local files
COPY  root /
COPY --from=compilingqB  /qbittorrent  /

RUN \
	echo "**** install packages ****" \
#	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk add --no-cache bash  ca-certificates  tzdata  python3 \
	&& rm -rf /var/cache/apk/*   \
	&& chmod a+x  /defaults/updatetrackers.sh  \
	&& chmod a+x  /usr/local/bin/qbittorrent-nox  

# ports and volumes
VOLUME /mnt /config
EXPOSE 8989  8999  8999/udp
ENTRYPOINT [ "/init" ]