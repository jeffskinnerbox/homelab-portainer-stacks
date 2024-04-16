<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.0
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Trilium Notes
Trilium Notes is a hierarchical note taking application.
It can work decently as a simple note taker
but also works as a knowledge base - tool to record, catalogize and process
all kinds of information and keep them long-term.

Trilium Notes is a hierarchical and wiki style notes, where you have relational map,
link between nodes, attributes, graph render (like pay chart), tracker,
notes by date like a journal, calendar, todo list, task manager, embedded pdf viewer,
code syntax highlighting, you can include pictures, photo album, note versioning,
note encryption, scripting, Web clipper, etc.

Features:

* Notes can be arranged into arbitrarily deep tree, single note can be placed into multiple places in the tree
* Rich WYSIWYG note editing including e.g. tables, images and math with markdown autoformat
* Support for editing notes with source code, including syntax highlighting
* Fast and easy navigation between notes, full text search and note hoisting
* Note attributes can be used for note organization, querying and advanced scripting
* Sync your data (notes, documents, bookmarks, etc.) across your different devices and to the cloud.
* Save any page or content from the web with a single click with Trilium Notes.
* Trilium Notes is easy to customize with themes or similar features.

Sources:

* [zadam/trilium](https://hub.docker.com/r/zadam/trilium)
* [Trilium Notes Wiki](https://github.com/zadam/trilium/wiki)
    * [Docker server installation](https://github.com/zadam/trilium/wiki/Docker-server-installation)


------


# Install Trilium Notes
I prefer to launch Trilium Notes via `docker-compose`, use the following file:

>**NOTE:** It's not recommended to use "latest" tag since it may upgrade your Trilium instance
>to a new minor version, which may potentially break your sync setup or cause other issues.

```yaml
version: '3'
services:
  trilium:
    image: zadam/trilium:${TRILIUM_TAG}
    container_name: trilium-notes
    restart: unless-stopped
    ports:
      - ${TRILIUM_PORT}:8080
    volumes:
      - ${TRILIUM_VOLUME}:/home/node/trilium-data
```

To do the install, execute the following commandline:

```bash
# start the docker container
sudo TRILIUM_PORT=5001 \
     TRILIUM_TAG="0.55-latest" \
     TRILIUM_VOLUME="/home/jeff/src/docker-containers/trilium-notes/trilium-data" \
     docker-compose --file ./trilium-notes-compose.yml up -d

# check for any errors during the install via
sudo docker logs trilium-notes
```

An alterenative method is via `docker` directly
using the following Docker commands to deploy the Portainer Server:

```bash
# create the volume for storing persistent data
cd ~/src/docker-containers/portainer
sudo docker volume create ./portainer-data

# install the portainer container (ports 9001 is for agents and 9000 for web ui)
sudo docker run -d -p 5001:8080 --name=trilium-notes --restart=always \
     -v /home/jeff/src/docker-containers/trilium-notes/trilium-data:/home/node/trilium-data \
     zadam/trilium:0.55-latest

# check if portainer is running
sudo docker ps -a -s
```

Now using your browser, log into portainer via this URL: `localhost:5001`.


-----

# How to Upgrade Trilium Notes
Trilium does not have a built-in auto upgrade,
soall upgrades have to be done manually.
For Docker installations you pull the image of the newer version and restart.

## Update Your Docker Container
You can update you Docker containers via the commandline,
but Portainer provides a intuitive browser UI to do the same.
Check out these videos:

* [Use Portainer to update your Docker Containers while they are running. No command line needed](https://www.youtube.com/watch?v=Eme2TlR7Z7E)
* [How to Update a Docker Container using Portainer](https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/)

## Removing Trilium Images & Containers
If you run into problems, log into it or kill Trilium
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).

How to do this is shown below:

```bash
# log into the trilium-notes docker container and check out its operational status
sudo docker exec -it trilium-notes bash

# kill the container
sudo docker kill trilium-notes

# remove the container image
sudo docker rmi zadam/trilium:0.55-latest

# list any dangling images
sudo docker images -f dangling=true
```

This final step you **may not** want to perform.
It will delete the configuration and database record files you have created via Trilium Notes.
At a minimum, you might want to create a copy of the data files.

```bash
# remove trilium's persistent data files
sudo rm -f -r trilium-data
```

Another clean up step you **may no** want to perform is of dangling and unreferenced
unused containers, networks, images.

```bash
# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)


------


# Setup Trilium Notes
