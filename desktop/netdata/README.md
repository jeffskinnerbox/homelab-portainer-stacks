<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Netdata
[Netdata][01] is an open source tool designed to collect real-time metrics,
such as CPU usage, disk activity, bandwidth usage, website visits, etc.,
and then display them in live, easy-to-interpret charts.
Netdata's a distributed, real-time monitoring Agent collects thousands of metrics
from systems, hardware, containers, and applications with zero configuration.
It runs permanently on all your physical/virtual servers,
containers, cloud deployments, and edge/IoT devices,
and is safe to install on your systems mid-incident without any preparation.

You can install Netdata via the Linux package management system or via Docker.
Instead, I'm using the [offical Netdata Docker image][02].

Sources:

* [How to Install Netdata on Ubuntu 22.04](https://wiki.crowncloud.net/?how_to_Install_netdata_monitoring_tool_ubuntu_22_04)
* [How to Install Netdata Monitoring Tool on Ubuntu 20.04](https://linuxhint.com/how-to-install-netdata-monitoring-tool-on-ubuntu-20-04/)
* [Using docker compose yml to run netdata](https://vmnet8.github.io/2020/02/12/Using-docker-compose-yml-to-run-netdata/)
* [Install Netdata with Docker](https://learn.netdata.cloud/docs/agent/packaging/docker)

# Install Netdata
I prefer to launch Homer via `docker-compose`, use the following file:

```yaml
# place this in file netdata-docker-compose.yml
version: '3'
services:
  netdata:
    container_name: netdata
    image: netdata/netdata:latest
    hostname: ${NETDATA_HOST_NAME}       # set to fqdn of host
    ports:
      - ${NETDATA_PORT}:19999
    restart: unless-stopped
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor:unconfined
    volumes:
      - /home/jeff/tmp/docker-volumes/netdata/netdataconfig:/etc/netdata
      - /home/jeff/tmp/docker-volumes/netdata/netdatalib:/var/lib/netdata
      - /home/jeff/tmp/docker-volumes/netdata/netdatacache:/var/cache/netdata
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro
```

To do the install, execute the following commandline:

```bash
# start the docker container
sudo NETDATA_PORT=19999 NETDATA_HOST_NAME=$(hostname) docker-compose --file ./netdata-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs netdata
```

An alterenative method is via `docker` directly:

```bash
# launch netdata container via docker
sudo docker run -d --name="netdata" \
  -p 19999:19999 \
  -v netdataconfig:/etc/netdata \
  -v netdatalib:/var/lib/netdata \
  -v netdatacache:/var/cache/netdata \
  -v /etc/passwd:/host/etc/passwd:ro \
  -v /etc/group:/host/etc/group:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata
```

## Removing Netdata Images & Containers
If you run into problems, kill the Homer dashboard
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill netdata

# remove the container image
sudo docker rmi netdata/netdata

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)



[01]:https://www.netdata.cloud/
[02]:https://hub.docker.com/r/netdata/netdata
[03]:
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
