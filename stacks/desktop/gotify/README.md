<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.0
-->

<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>

---------------

# Gotify

[Gotify][01] self-hosted Docker container that makes sending & receiving real-time notifications/messages easy.
By self-hosted your notifications your data isn't be used by any of the comercial servers in the market.
It send messages via REST-API and receive messages via WebSocket.
It provides a [Web user interface][05],
[commandline interface][06] for sending messages,
and [Android app][07] for your phone,
and it support a [plugins][08] to extend its capabilities.

Sources:

* [GitHub: gotify/server][03] - A simple server for sending and receiving messages in real-time per WebSocket.
* [DockerHub: gotify/server][04] - Docker container for locally hosted Gotify Server
* [GitHub: gotify/cli][09] - A command line interface for pushing messages to gotify/server.
* [Gotify Documentation][02] - Documentation of gotify/server for user and developers.

---------------

## Installation of Gotify

* [Gotify: My New Favorite Way To Get Notified!](https://www.youtube.com/watch?v=mIVHxFrFKqQ)
* [Create Notifications For ANYTHING Using Gotify (Crowdsec, Cron Jobs, Scripts, Uptime, File Copy)](https://www.youtube.com/watch?v=Ft69PY7iitw)

#### Step 1: Quick Test of Gotify

To get things going quickly, you can use the script below:

```bash
# change directory to where you want your data stored,
# I assume is where the docker-compose file resides
cd ~/src/homelab-portainer-stacks/stacks/desktop/gotify

# test script for gotify, update environment variable as needed
sudo docker run -p 8070:80 -e TZ="America/New_York" -v ~/src/homelab-portainer-stacks/stacks/desktop/gotify/data:/app/data gotify/server
```

When the Gotify server starts, go to its Web GUI at `http://localhost:8070`, in my case.
On the UI, enter the default user & password:

* **User**: admin
* **Pasword**: admin

See below to kill and cleanup when testing is completed.

If you prefer a permanent setup, as I do, to launch WatchYourLAN via `docker-compose` on Portainer,
you can do that in the subsequent steps.

#### Step 2: Docker Compose File for Gotify

For a more perminate solution (using Docker Compose), you can use the script below.

```bash
sudo docker compose up --detach
```

The above command should use the `docker-compose.yml` file listed below:

```bash
version: "3"
services:
  gotify:
    image: gotify/server
    container_name: gotify
    restart: unless-stopped
    ports:
      - 8070:80
    environment:
      - TZ="America/New_York"
    volumes:
      - "~/src/homelab-portainer-stacks/stacks/desktop/gotify/data:/app/data"
```

#### Step X: Configure the Gotify Server

#### Step X: xxx

#### Step X: xxx

#### Step X: Update Your Docker Container

You can install you Docker containers via the `docker`
and `docker compose` commandline tools,
but Portainer provides a intuitive browser UI to do the same
using the `docker-compose.yml` file stoed in GitHub.
To use this approach, you need to add the following to Portainer:

* **Name** `gotify`
* **Repository URL** `https://github.com/jeffskinnerbox/homelab-portainer-stacks`
* **Repository reference** ``
* **Compose path** `stacks/desktop/gotify/docker-compose.yml`

For more information, check out these videos:

* [Use Portainer to update your Docker Containers while they are running. No command line needed](https://www.youtube.com/watch?v=Eme2TlR7Z7E)
* [How to Update a Docker Container using Portainer](https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/)

---------------

## Removing Gotify Images & Containers

If you run into problems, kill the running Gotify
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# log into the docker container and check out its operational status
sudo docker exec -it gotify bash

# kill the container
sudo docker kill gotify

# remove the container image
sudo docker rmi gotify/server

# list any dangling images
sudo docker images -f dangling=true
```

This final step you **may not** want to perform.
It will delete the configuration and database record files
you have created via Gotify.
At a minimum, you might want to create a copy of the data files.

```bash
# copy or trash gotify's persistent data files
sudo cp ~/src/homelab-portainer-stacks/stacks/desktop/gotify/data ~/tmp/gotify/data

# remove or trash gotify's persistent data files
sudo trash ~/src/homelab-portainer-stacks/stacks/desktop/gotify/data
sudo rm -f -r ~/src/homelab-portainer-stacks/stacks/desktop/gotify/data
```

Another clean up step you **may no** want to perform is of dangling and unreferenced
unused containers, networks, images.

```bash
# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

[01]:https://gotify.net/
[02]:https://gotify.net/docs/index
[03]:https://github.com/gotify/server
[04]:https://hub.docker.com/r/gotify/server
[05]:https://github.com/gotify/server/tree/master/ui
[06]:https://github.com/gotify/cli
[07]:https://github.com/gotify/android
[08]:https://gotify.net/docs/plugin
[09]:https://github.com/gotify/cli
