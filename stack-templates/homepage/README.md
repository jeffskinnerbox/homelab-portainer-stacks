<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


# Homepage

Sources:
* [Homepage](https://gethomepage.dev/latest/)
* [Meet Homepage - Your HomeLab Services Dashboard](https://technotim.live/posts/homepage-dashboard/)

## Install Homepage

```bash
# launch homepage container via docker
docker run -p 8084:3000 -v /path/to/config:/app/config -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/gethomepage/homepage:latest
```

If you prefer to launch Homepage via `docker-compose`, use the following
(**NOTE:** To get your UID & GID, execute `id` in a terminal):

```yaml
# homepage - https://gethomepage.dev/latest/

version: "3.3"
services:
  homepage:
    container_name: homepage
    image: "ghcr.io/gethomepage/homepage:latest"
    restart: unless-stopped
    #env_file: /home/jeff/src/docker-containers/homepage/config/.env
    #env_file: .env
    ports:
      - 8084:3000
    volumes:
      - /home/jeff/src/docker-containers/homepage/config:/app/config   # make sure your local config directory exists
      - /var/run/docker.sock:/var/run/docker.sock                      # (optional) For docker integrations
    environment:                                                       # read them from .env
      PUID: 1000
      PGID: 1000
```

```bash
# start the docker container
sudo docker-compose --file ./homepage-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs homepage
```

## Removing Images & Containers
If you run into problems, kill the Homepage dashboard
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill homepage

# remove the container
sudo docker rm homepage

# remove the container image
sudo docker rmi ghcr.io/gethomepage/homepage

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

