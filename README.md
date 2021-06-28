# 我的博客
http://blog.auska.win

## 创建镜像

```
docker create --name=qBittorrent \
-v <path to downloads>:/mnt \
-v <path to config>:/config \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-p 8999:8999 -p 8989:8989 \
auska/docker-qbittorrent
```

## 参数解释

* `-p 8989` 网页UI端口
* `-p 8999` - BT软件通讯端口
* `-v /config` - 配置文件目录
* `-v /mnt` - 下载文件目录
* `-v /watch` - 监视种子目录
* `-e PGID` 用户的GroupID，留空为root
* `-e PUID` 用户的UserID，留空为root
* `-e TZ` 时区 默认 Asia/Shanghai

默认登陆账户/密码：admin/adminadmin

## 版本介绍

latest ： 使用了最新的QB的源码编译的。
1.X    ： 功能与latest版本相同，但使用libtorrent 1.1.X 编译。
