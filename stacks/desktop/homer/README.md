<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


# Homer
Homer is a static dashboard, residing in a Docker container,
generated from the source in its `/src` directory.
Its setup and controlled via a YAML configuration making it simple to use.
It has a nice default scheme that your can modify to suit your taste.
With Homer, you can create a simple to maintain and attractive dashboard to access your applications.

Sources:

* [Homer](https://github.com/bastienwirtz/homer#getting-started)
* [Homer Docker Image](https://hub.docker.com/r/b4bz/homer)
* [Homer Dashboard - Open Source, Self Hosted, Beautiful Shortcuts to all your sites and services](https://www.youtube.com/watch?v=7re4LlJGBXE)
* [Installing Homer Dashboard with Docker](https://tcude.net/installing-homer-dashboard-with-docker/)
* [Configuring Homer Dashboard](https://tcude.net/configuring-homer-dashboard/)
* [Creating a Dashboard for Your Home Servers using Homer](https://www.yeetpc.com/blog/homer-services-dashboard/)
* [This Homelab Dashboard is simple and beautiful!](https://www.youtube.com/watch?v=9iTPm45EmxM)
* [Homer Dashboard - Open Source, Self Hosted, Beautiful Shortcuts to all your sites and services](https://www.youtube.com/watch?v=7re4LlJGBXE)

Check out the following

* [Tips & Tricks](https://github.com/bastienwirtz/homer/blob/main/docs/tips-and-tricks.md)

## Install Homer

```bash
# launch homer container via docker
sudo HOMER_PORT=8001 HOMER_HOME='/home/jeff/src/docker-containers/homer' docker run -d \
  -p 8001:8080 \
  -v ${HOMER_HOME}/assets/assets/:/www/assets \
  --name="homer" \
  --restart=always \
  b4bz/homer:latest
```

If you prefer to launch Homer via `docker-compose`, use the following
(**NOTE:** To get your UID & GID, execute `id` in a terminal):

```yaml
# launch homer via docker-compose
# place this in file homer-docker-compose.yml
version: "3"
services:
  app:
    image: 'b4bz/homer:latest'
    container_name: homer
    restart: unless-stopped
    ports:
      - ${HOMER_PORT}:8080
    volumes:
      - ${HOMER_HOME}/assets/:/www/assets
    environment:
      - UID=1000
      - GID=1000
```

```bash
# start the docker container
sudo HOMER_PORT=8001 HOMER_HOME='/home/jeff/src/docker-containers/homer' docker-compose --file ./homer-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs homer
```

## Removing Images & Containers
If you run into problems, kill the Homer dashboard
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill homer

# remove the container
sudo docker rm homer

# remove the container image
sudo docker rmi b4bz/homer

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

# Homer Color Scheme
You can create a well matched color palette scheme with the site [Coolors](https://coolors.co/).

# Homer Icons
You can find icons suitable for the Homer dashboard at the following sites:

* [Homer Icons](https://github.com/NX211/homer-icons)
* [Font Awesome](https://fontawesome.com/start)

```bash
# move to the icons directory
cd ~/src/docker-containers/homer/assets/icons

# download the icon
wget https://raw.githubusercontent.com/NX211/homer-icons/master/png/pfsense.png
```
