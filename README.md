<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


desktop           192.168.1.200
synology          192.168.1.201:9001
router-firewall   192.168.1.204:9001
test-pi           192.168.1.205:9001
print-server



Connect existing Portainer agent to new Portainer host - https://www.reddit.com/r/portainer/comments/xmdbt1/connect_existing_portainer_agent_to_new_portainer/
    do this: `sudo docker restart portainer-agent`


# Best Port Numbers
The IANA stests the standards for ports.
What would be the best IANA port range to use for these apps in order to avoid port number collisions with any other process on the server?
Docker itself uses port numbers from 32768-65535

* [Best TCP port number range for internal applications](https://stackoverflow.com/questions/10476987/best-tcp-port-number-range-for-internal-applications)
* [Why docker uses port numbers from 32768-65535?](https://stackoverflow.com/questions/40787524/why-docker-uses-port-numbers-from-32768-65535)
* [A Brief Primer on Docker Networking Rules: EXPOSE, -p, -P, --link](https://www.ctl.io/developers/blog/post/docker-networking-rules)
* [Docker networking is CRAZY!! (you NEED to learn it)](https://www.youtube.com/watch?v=bKFMS5C4CG0)
* [Understanding Docker Networking](https://earthly.dev/blog/docker-networking/)

# The 7 Types of Docker Networks
* [Docker networking is CRAZY!! (you NEED to learn it)](https://www.youtube.com/watch?v=bKFMS5C4CG0)
* [Understanding Docker Networking](https://earthly.dev/blog/docker-networking/)
* [Docker Networking Tutorial // ALL Network Types explained!](https://www.youtube.com/watch?v=5grbXvV_DSk&t=210s)
* [Docker Networking Overview](https://docs.docker.com/network/)
* [Docker Networking Options](https://www.youtube.com/watch?v=Yr6-2ddhLVo)











# HomeLab Portainer Stacks
Collection of docker-compose recipes for my HomeLab

* Desktop
    * **HomeLab Dashboard** is a very simple static homepage for your server.- [homer](https://github.com/bastienwirtz/homer) - http://192.168.1.200:8080
    * **Snippit Box** is a simple self-hosted app for organizing your code snippets. - [snippit](https://github.com/pawelmalak/snippet-box) - http://192.168.1.200:5000
* Router/Firewall

* Docker
* Docker Volumes - Volumes are a mechanism for storing data outside containers. All volumes are managed by Docker and stored in a dedicated directory on your host, usually `/var/lib/docker/volumes` for Linux systems. When containers write to a path beneath a volume mount point, the changes will be applied to the volume instead of the container’s writable image layer. The written data will still be available if the container stops – as the volume’s stored separately on your host, it can be remounted to another container or accessed directly using manual tools.
* Bind Mounts vs. Docker Volumes - Bind mounts are another way to give containers access to files and folders on your host. They directly mount a host directory into your container. Any changes made to the directory will be reflected on both sides of the mount, whether the modification originates from the host or within the container.
Bind mounts are best used for ad-hoc storage on a short-term basis. They’re convenient in development workflows. For example: bind mounting your working directory into a container automatically synchronizes your source code files, allowing you to immediately test changes without rebuilding your Docker image.
Volumes are a better solution when you’re providing permanent storage to operational containers. Because they’re managed by Docker, you don’t need to manually maintain directories on your host. There’s less chance of data being accidentally modified and no dependency on a particular folder structure. Volume drivers also offer increased performance and the possibility of writing changes directly to remote locations.
[Docker Volumes – Guide with Examples](https://spacelift.io/blog/docker-volumes)
* Docker Compose
* Docker Swarm
* Watch Tower
* Portainer
* GitHub
* CI/CD
* Docker Standalone environment (Agent, API, Socket, Edge Agent Standard, Edge Agent Async) - https://docs.portainer.io/admin/environments/add/docker

Portainer can be combined with a GitHub repo to allow for continuous deployment oaf Docker Swarm services,
allowing all the benefits of Git to be applied to your stack files.

Insperation for this GitHub site:
[heinrich-r/homelab-portainer-stacks](https://github.com/heinrich-r/homelab-portainer-stacks)
and the [Josh Buker Blog](https://joshbuker.com/archive/).


------


## Install Docker
Docker allows you to quickly spinning up containerized application, virtualized servers, and sandboxes.
It provides an incredibly fast and lightweight alternative to virtual machines
at the cost of less scaleability and isolation between the virtual environment and the host system.

>**NOTE:** If your considering using Docke Swarm,
>these instructions are not likely complete and/or correct.
>Handling Docker Swarm will be addressed at a later date.

### Installing on Ubuntu
Ubuntu is my go-to Linux OS and installing on Ubuntu is fairly straight-forward.
I'll used the installation scripts below.
This involves adding a new package source,
adding the GPG key from Docker to ensure the downloads are valid,
and then install the Docker package.

While not the absolute latest Docker version,
I’ll install Docker from the Dockers official Ubuntu repository,
instead of Docker's generic repository.

```bash
# before you can install docker engine, you need to uninstall any previous installed conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt remove $pkg; done

# clean up any existing docker related data
rm /var/lib/docker/*

# update your existing list of ubunutu packages
sudo apt update

# install a few prerequisite packages
sudo apt install apt-transport-https ca-certificates curl gnupg software-properties-common

# add docker's official gpg key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# add the docker repository to apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# check to make sure you are about to install from docker repo or ubuntu repo
apt-cache policy docker-ce
```

From the above last command,
you'll see the installation will be from the Docker repository for what ever version of Ubuntu you are running.
Now lets install Docker:

```bash
# install docker packages
sudo apt install docker-ce

# check to see if docker is running
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# docker should be running, but make sure
sudo service docker start

# verify that the docker engine installation is successful running
sudo docker run hello-world

# verify that the installation of docker compose was successful
docker compose version
```

### Upgrading Docker
Docker and Docker Compose will be automatically upgraded by Ubuntu from the official Ubuntu repository for Docker.


-------


## Portainer
Portainer consists of two elements, the Portainer Server and the Portainer Agent.
Both elements run as lightweight Docker containers on a Docker engine.
Portainer gives users a way to manage their Docker containers,
accross multiple sites, through a web interface.
Portainer also gives you the ability to use stacks,
which is an easy way to create new containers and allows them to be created using a docker-compose format.

### Installing on Ubuntu
>**NOTE:** These instructions below must be performed on Ubuntu 22.04 or greater.

```bash
# create the volume for storing persistent data
sudo docker volume create portainer_data

# install the portainer container (ports 8000 is for agents and 9000 for web ui)
sudo docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# check if portainer is running
sudo docker ps -a -s

# log into portainer and setup your password, etc.
#google-chrome https://localhost:9443   # <-- for https access
google-chrome https://localhost:9000   # <-- for http access
```

Now using your browser, log into portainer via this URL: `localhost:9000`.

### Upgrading Portainer
To [upgrade to the latest version of Portainer Server][40],
you must do it from the commandline.
Use the following commands to stop Portainer, then remove the old version,
and finally do a new install of Portainer.

```bash
# stop and remove the portainer container
sudo docker stop portainer
sudo docker rm portainer

# pull down the latest version of portainer
sudo docker pull portainer/portainer-ce:latest

# reinstall portainer
sudo docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

You may want to also upgrade the Portainer Agent and this must be done separately:

```bash
# stop and remove the portainer agent container
sudo docker stop portainer_agent
sudo docker rm portainer_agent

# pull nd start the updated version of the image
sudo docker pull portainer/agent:latest
sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest
```

**See [How to install Portainer](https://joshbuker.com/blog/how-to-install-portainer/) for stack implement of upgrading using Docker Swarm**


-------


## Git Repository for Portainer Stacks
This is it ... your GitHub Repository for Portainer Stacks!
This repository provides a SCS repository from which you can extract your Portainer Stacks automatically into Portainer.
Instead of uploading a stack or using the Web Editor on Portainer,
you can configure Portainer to pull your stack directly from GitHub.

It is easy to do, just follow these steps:

1. Within a Portainer's **Home** page, select the relevant **Environments**.
2. Within the **Dashboard** page, select **Stacks** from the lefthand menu.
3. Within the **Stack list** page, at the top right of the screen, click on the **+ Add stack** button.
4. Still within the **Create stack** page, on the **Name** line, give your stack a name (ex. `homer`).
5. Still within the **Create stack** page, from the **Build method** buttons, select **Repository**.
6. Still within the **Create stack** page, the **Authentication** slider should be turned **off**.
7. Still within the **Create stack** page, on the **Repository URL** line, enter top-level URL for your GitHub site
(ex. `https://github.com/jeffskinnerbox/homelab-portainer-stacks`).
8. Still within the **Create stack** page, on the **Repository reference** line, no modification.
9. Still within the **Create stack** page, on the **Compose path** line, enter path to your `docker-compose.yml` file
(ex. `stacks/desktop/homer/docker-compose.yml`).
10. Still within the **Create stack** page, at the bottom of the page, click on the **+Deploy the stack** button.


-------


# Future Inplementations

## Docker Swarm
Docker Swarm is an easy way to turn multiple computers into a automatically load balanced
set of Docker services you spin upand manage it with Portainers help.
Before you create a Docker Swarm,
you’ll need to install Docker on all of the nodes (computers) you’ll be using in the swarm.
You can do this with as few as one manager node, and one worker node.

* [How to create a Docker Swarm](https://joshbuker.com/blog/how-to-create-a-docker-swarm/)
* [Docker.Docs: Create a swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/)
* [Install Portainer CE with Docker Swarm on Linux](https://docs.portainer.io/start/install-ce/server/swarm/linux)
* [How to install Portainer](https://joshbuker.com/blog/how-to-install-portainer/)

# Sources
* [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [Install the Compose plugin](https://docs.docker.com/compose/install/linux/#install-using-the-repository)
* [How to Install Portainer on Ubuntu](https://www.wundertech.net/portainer-on-ubuntu/)
* [Install Portainer CE with Docker on Linux](https://docs.portainer.io/start/install-ce/server/docker/linux)



[40]:https://docs.portainer.io/v/ce-2.9/admin/upgrade/docker

