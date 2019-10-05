# My Blog
http://blog.auska.win

## Usage

```
docker create --name=qBittorrent \
-v <path to downloads>:/mnt \
-v <path to config>:/config \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-p 8999:8999 -p 8989:8989 \
auska/docker-qbittorrent
```

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Versions

+ **0.0.2:** Update QB 4.1.8.1.
+ **0.0.1:** Rebase to alpine linux 3.10.