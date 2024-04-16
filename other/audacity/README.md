<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


[Audacity][01] is free and open source cross-platform software for recording and editing sounds.
Audacity can be used for post-processing of all types of audio,
including podcasts by adding effects such as normalization, trimming, and fading in and out.
Check out Audacity's online [user manual][02] and [documentation][03] for more information.

To run Audacity, we'll need to run the following command in a terminal or shell.

```bash
# pull the docker container from dockerhub
sudo docker pull linuxserver/audacity

# see https://hub.docker.com/r/linuxserver/audacity
sudo docker run -d \
    --name=audacity \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -e TZ=America/New_York \
    -p 3000:3000 \
    -v /home/jeff/src/docker-containers/audacity/config:/config \
    --restart unless-stopped \
    lscr.io/linuxserver/audacity
```

Docker containers are not automatically removed when you stop them
(unless you start the container using the `--rm` flag).
To remove the audacity container:

```bash
# list the container ids
$ sudo docker container ls -a | grep audacity |  awk '{ print $1 }'
f04cf7e88a69

# remove the audacity container from computer
docker container rm f04cf7e88a69
```

If you want to remove the image of the container,
do the following:

```bash
# list the container images
$ sudo docker images -a | grep audacity | awk '{ print $3 }'
e9cc7cda22c8

# remove the audacity image from computer
sudo docker rmi e9cc7cda22c8
```

When using volumes (`-v` flags),
permissions issues can arise between the host OS and the container.
To avoid this issue, you should specify the user PUID and group PGID.
Ensure any volume directories on the host are owned by the same user you specify
and any permissions issues should vanish.



[01]:https://www.audacityteam.org/
[02]:https://manual.audacityteam.org/
[03]:https://www.audacityteam.org/help/documentation/
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
