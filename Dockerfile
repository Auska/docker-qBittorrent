FROM alpine:3.12 as compilingqB

#compiling qB

ENV LT=v1.2.12 QT=release-4.3.2

RUN apk add --no-cache wget curl bash \
&& mkdir /qbtorrent \
&& cd /qbtorrent \
&& wget https://github.com/userdocs/qbittorrent-nox-static/raw/master/qbittorrent-nox-static.sh \
&& bash qbittorrent-nox-static.sh all -b "/qbtorrent" -lt $LT -qt $QT
 

# docker qB

FROM lsiobase/alpine:3.12

# set version label
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin TRACKERSAUTO=Yes WEBUIPORT=8989 PGID=0 PUID=0 UMASKSET=022 FIX=YES

# copy local files
COPY root /
COPY --from=compilingqB /qbtorrent/completed/qbittorrent-nox /usr/local/bin/qbittorrent-nox

RUN \
	echo "**** install packages ****" \
#	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk add --no-cache bash ca-certificates tzdata python3 \
	&& rm -rf /var/cache/apk/* \
	&& chmod a+x /defaults/updatetrackers.sh \
	&& chmod a+x /usr/local/bin/qbittorrent-nox 

# ports and volumes
VOLUME /mnt /config
EXPOSE 8989 8999 8999/udp
ENTRYPOINT [ "/init" ]