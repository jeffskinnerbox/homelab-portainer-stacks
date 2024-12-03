<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


[Excalidraw - A Self Hosted Diagram and Drawing Portal](https://noted.lol/excalidraw/)
[Homelab Series - Creating a Excalidraw Server - Whiteboard to Sketch Diagrams](https://www.youtube.com/watch?v=szv-z9pYTAs)


----


# Excalidraw
An open source virtual collaborative whiteboard for sketching hand-drawn like diagrams and text.
You can use it to self-host your own client under your own domain.

What is the difference between Excalidraw and Excalidraw+? - https://plus.excalidraw.com/excalidraw-plus-vs-excalidraw

[Excalidraw+](https://plus.excalidraw.com/)
[Online Excalidraw editor](https://excalidraw.com/)
[Excalidraw Blog](https://blog.excalidraw.com/)
[Excalidraw developer docs](https://docs.excalidraw.com/)
[]()
[Excalidraw Libraries](https://libraries.excalidraw.com/)

Sources:

## Install Excalidraw
Excalidraw publishs a Docker image of the Excalidraw client at DockerHub [excalidraw/excalidraw][01].
The Docker image is free of analytics and other tracking libraries.
At the moment, self-hosting your own instance doesn't support sharing or collaboration features,
but Excalidraw is working towards a full-fledged solution for self-hosting.

```bash
# launch excalidraw container via docker on commandline
docker run -d \
  -v /home/jeff/src/docker-volumes/excalidraw/:/opt/node_app/app:delegated \
  -v /home/jeff/src/docker-volumes/excalidraw/package.json:/opt/node_app/package.json \
  -v /home/jeff/src/docker-volumes/excalidraw/yarn.lock:/opt/node_app/yarn.lock \
  -e NODE_ENV=production \
  -p 8082:8080 \
  --name="excalidraw" \
  --restart=unless-stopped \
  excalidraw/excalidraw:latest
```

If you prefer to launch Excalidraw via `docker-compose`, use the following
(taken from [here][02]):

```yaml
# launch excalidraw via docker-compose - place this in file excalidraw-docker-compose.yml
version: "3.8"

services:
  excalidraw:
    image: excalidraw/excalidraw:latest
    container_name: excalidraw
    ports:
      - ${EXCALIDRAW_PORT}:80
    restart: unless-stopped
    stdin_open: true
    healthcheck:
      disable: true
    environment:
      - NODE_ENV=production
    volumes:
      - ${EXCALIDRAW_VOL}/:/opt/node_app/app:delegated
      - ${EXCALIDRAW_VOL}/package.json:/opt/node_app/package.json
      - ${EXCALIDRAW_VOL}/yarn.lock:/opt/node_app/yarn.lock
      - notused:/opt/node_app/app/node_modules

volumes:
  notused:
```

To start Excalidraw container via `docker-compose`,
use the following command:

```bash
# start the docker container via
sudo EXCALIDRAW_PORT=8082 EXCALIDRAW_VOL='/home/jeff/src/docker-volumes/excalidraw' docker-compose --file ./excalidraw-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs excalidraw
```

## Removing Images & Containers
If you run into problems,
kill Excalidraw and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill excalidraw

# remove the container
sudo docker rm excalidraw

# remove the container image
sudo docker rmi excalidraw/excalidraw

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune

# to remove any excalidraw volumes
rm -r -f /home/jeff/src/docker-volumes/excalidraw
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)


----


# Configuring Excalidraw


-----


# Backup
[How I Put My Mind Under Version Control](https://medium.com/analytics-vidhya/how-i-put-my-mind-under-version-control-24caea37b8a5)



[01]:https://hub.docker.com/r/excalidraw/excalidraw
[02]:https://github.com/excalidraw/excalidraw/blob/master/docker-compose.yml
[03]:
[04]:
[05]:

