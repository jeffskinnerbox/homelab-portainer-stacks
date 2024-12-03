<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.0
-->

<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>

---------------

# Pushtify

[Gotify][01] self-hosted Docker container that makes sending & receiving
real-time notifications/messages easy.
I use Gotify as my single notification tool for my homelab infrastructure.
To receive those same notifications on my mobile phone,
I choose not to use [Gotify's app][02] but [Pushover][03] instead.
So I need someway to forward my Gotify messages to Pushover.

Gotify has an Android mobile app
but I'm already using Pushover's mobile app and it available on iOS & Android.
Another benefit of Pushover its a well established cloud-PaaS notification system
(closed source but free for light utilization).
This give me a fallback if Gotify future isn't solid.

So I could continue to use Pushover,
I choose [Pushtify][04] as my Gotify-to-Pushover forwarder.
[Pushtify come in a Docker container][05] and should be easy to install and operate.

---------------

## Installation of Pushtify

Well need the following:

* a client token in Gotify
* the Gotify hostname
* a Pushover user key

You can convert the Docker commandline provided on the [Github site][04]
to `docker compose` formate via [this website][06]:

```bash
# this docker run command
docker run --name pushtify -e GOTIFY_TOKEN=zzz -e GOTIFY_HOST=gotify.example.org -e PUSHOVER_USERKEY=xxx ghcr.io/sebw/pushtify:latest
```

This is converted to:

```yaml
version: "3"
services:
    pushtify:
        container_name: pushtify
        environment:
            - GOTIFY_TOKEN=zzz
            - GOTIFY_HOST=gotify.example.org
            - PUSHOVER_USERKEY=xxx
        image: ghcr.io/sebw/pushtify:latest
```

This leads me to my `docker-compose.yml` file:

```yaml
---

version: "3"
services:
  pushtify:
    image: sebastienw/pushtify:latest
    container_name: pushtify
    restart: unless-stopped
    environment:
        - GOTIFY_TOKEN=zzz
        - GOTIFY_HOST=gotify.example.org
        - PUSHOVER_USERKEY=xxx
```

Combining Pushtify with Gotify we get:

```yaml
---

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

  pushtify:
    image: sebastienw/pushtify:latest
    container_name: pushtify
    restart: unless-stopped
    environment:
      - GOTIFY_TOKEN="ChEho62Mz.xUHl3"
      - PUSHOVER_USERKEY="u7pVGpnNFYQHy9aUNcyEVKGfzqezyx"
      - GOTIFY_HOST="localhost:8070"
```

---------------

## Removing Pushtify Images & Containers

If you run into problems, kill the running Pushtify
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# log into the docker container and check out its operational status
sudo docker exec -it pushtify bash

# kill the container
sudo docker kill pushtify

# remove the container image
sudo docker rmi sebw/pushtify

# list any dangling images
sudo docker images -f dangling=true
```

This final step you **may not** want to perform.
It will delete the configuration and database record files
you have created via Pushtify.
At a minimum, you might want to create a copy of the data files.

```bash
# copy or trash pushtify's persistent data files
sudo cp ~/src/homelab-portainer-stacks/stacks/desktop/pushtify/data ~/tmp/pushtify/data

# remove or trash pushtify's persistent data files
sudo trash ~/src/homelab-portainer-stacks/stacks/desktop/pushtify/data
sudo rm -f -r ~/src/homelab-portainer-stacks/stacks/desktop/pushtify/data
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
[02]:https://play.google.com/store/apps/details?id=com.github.gotify&pli=1
[03]:https://play.google.com/store/search?q=pushover&c=apps
[04]:https://github.com/sebw/pushtify
[05]:https://hub.docker.com/r/sebastienw/pushtify
[06]:https://www.composerize.com/
