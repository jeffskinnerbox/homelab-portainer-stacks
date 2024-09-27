<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.0
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


---------------


# WatchYourLAN
WatchYourLAN is a lightweight, continuiously operating network IP scanner with web GUI.
It can be used to notify you about new hosts,
maintains a list of all hosts in the network,
log host online/offline history,
and sends data to InfluxDB2 to make a Grafana dashboard.
It is packaged as a Docker Container and can be found on DockerHub as [aceberg/watchyourlan][03].

Currently `docker0` is not allowed, as arp-scan wouldn't work with it correctly

Sources:

* [Homelab Series - Setup WatchYourLan Server - Network IP Scanner for your LAN](https://www.youtube.com/watch?v=Zs9sKx8rXrs)
* [This is How You WatchYourLan](https://www.youtube.com/watch?v=DknqJrnlLQo)
* [Pi.Alert or WatchYourLAN can alert you to unknown devices appearing on your WiFi or LAN network](https://www.youtube.com/watch?v=v6an9QG2xF0)


#### Step X: Idenify Your LAN & WiFi Interfaces to Scan
You'll need one WatchYourLAN instance on each of your subnets to get a complet picture of host activity.
In my case, I have my 'geast' accessible network which also incldues my Fios TV, IoT devices, camera, etc.
Firewalled off from this network is my homelab network.
Both these will require a MonitorYourLAN insatance.

Each WatchYourLAN needs to be made aware of the IP network interfacde it must listen too.
To get the network interfaces, you need to scan to each network for interface data,
useing the following script:

```bash
# list your network interfaces
sudo ip link show
```


#### Step X: Quick Start WatchYourLAN for Testing
To get htings going quickly, you can use the script below:

```bash
# change directory to where you want your data stored,
# I assume is where the docker-compose file resides
cd ~/src/homelab-portainer-stacks/stacks/desktop/watchyourlan

# test script for watchyourlan, update environment variable as needed
sudo PORT="8840" YOURIFACE="enp4s0 wlx94dbc95110ca" YOURTIMEZONE="America/New_York" \
    DOCKERDATAPATH="~/src/homelab-portainer-stacks/stacks/desktop/watchyourlan/data" docker run -d \
    -p $PORT:8840 \
    --name "watchyourlan" \
    --hostname "watchyourlan" \
    --network="host" \
    --env "IFACES=$YOURIFACE" \
    --env "TZ=$YOURTIMEZONE" \
    --volume $DOCKERDATAPATH/wyl:/data/WatchYourLAN \
    aceberg/watchyourlan:v2
```

When WatchYourLan starts, go to its Web GUI at `http://localhost:8840`, in my case.
See below to kill and cleanup when testing is completed.

If you prefer a permanent setup, as I do, to launch WatchYourLAN via `docker-compose` on Portainer,
you can do that in the subsequent steps.


#### Step X: Docker Compose File for WatchYourLAN

```yaml
version: "3"
services:
  watchyourlan:
    container_name: watchyourlan
    host_name: watchyourlan
    image: aceberg/watchyourlan:v2
    network_mode: "host"                # needs access to host network to do network scan
    restart: unless-stopped
    ports:
      - 8840:8840                       # watchyourlan web gui at http://localhost:8840
    volumes:
      - ~/src/homelab-portainer-stacks/stacks/desktop/watchyourlan/data:/data/WatchYourLAN   # sqlite data will be stored here
    environment:
      TZ: America/New_York              # required: needs your TZ for correct time
      IFACE: "enp4s0 wlx94dbc95110ca"   # required: interface to scan, could be one or more, separated by space
      HOST: "0.0.0.0"                   # optional, default: 0.0.0.0
      PORT: "8840"                      # optional, default: 8840
      TIMEOUT: "120"                    # optional, time in seconds, default: 120
      SHOUTRRR_URL: ""                  # optional, url for notification service: Shoutrrr (pushover, email, telegram and others)
      THEME: "sand"                     # optional
      COLOR: "dark"                     # optional
```

Sources:

* [Beginners Guide to Containers and Stacks in Portainer : How to set up Fast](https://www.youtube.com/watch?v=_g6QFm0-Umg)


#### Step X: Test GUI
WatchYourLAN will serve its Web GUI at `http://localhost:8840` (aka `http://desktop:8840` in my case).


#### Step X: Update Your Docker Container
You can update you Docker containers via the commandline,
but Portainer provides a intuitive browser UI to do the same.
Check out the videos:

* [Use Portainer to update your Docker Containers while they are running. No command line needed](https://www.youtube.com/watch?v=Eme2TlR7Z7E)
* [How to Update a Docker Container using Portainer](https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/)


## Removing WatchYourLAN Images & Containers
If you run into problems, kill the running WatchYourLAN
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# log into the docker container and check out its operational status
sudo docker exec -it watchyourlan bash

# kill the container
sudo docker kill watchyourlan

# remove the container image
sudo docker rmi aceberg/watchyourlan

# list any dangling images
sudo docker images -f dangling=true
```

This final step you **may not** want to perform.
It will delete the configuration and database record files you have created via WatchYourLAN.
At a minimum, you might want to create a copy of the data files.

```bash
# copy or trash WatchYourLAN's persistent data files
sudo cp ~/src/homelab-portainer-stacks/stacks/desktop/watchyourlan/data ~/tmp/watchyourlan/data

# remove or trash WatchYourLAN's persistent data files
sudo trash ~/src/homelab-portainer-stacks/stacks/desktop/watchyourlan/data
sudo rm -f -r ~/src/homelab-portainer-stacks/stacks/desktop/watchyourlan/data
```

Another clean up step you **may no** want to perform is of dangling and unreferenced
unused containers, networks, images.

```bash
# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)





[01]:
[02]:
[03]:https://hub.docker.com/r/aceberg/watchyourlan
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
