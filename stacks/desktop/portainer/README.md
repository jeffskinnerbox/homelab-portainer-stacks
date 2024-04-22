<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Portainer
Adopting container orchestration platforms like Kubernetes can be hard.
[Portainer][61] is a popular Docker UI that helps you visualise your
containers, images, volumes and networks.
Portainer helps you centrally configure, manage and secure containerized environments,
regardless of where they are hosted.
It helps you take control of the Docker resources on your machine, avoiding lengthy terminal commands.

Portainer can be deployed to Docker, Docker Swarm, or Kubernetes environments
and comprised of two elements: the Portainer Server, and the Portainer Agent.
I going to deploy Portainer via Docker below.

Sources:

* [Deploying Portainer CE in Docker](https://documentation.portainer.io/v2.0/deploy/ceinstalldocker/)
* [How to Install Portainer Docker UI Manager on Ubuntu 20.04 | 18.04 | 16.04](https://docs.fuga.cloud/how-to-install-portainer-docker-ui-manager-on-ubuntu-20.04-18.04-16.04)
* [How to Install Portainer 2.0 on your Docker](https://www.letscloud.io/community/how-to-install-portainer)
* [How to Get Started With Portainer, a Web UI for Docker](https://www.cloudsavvyit.com/8911/how-to-get-started-with-portainer-a-web-ui-for-docker/)
* [Portainer Install Ubuntu tutorial - manage your docker containers](https://www.youtube.com/watch?v=ljDI5jykjE8)


------


# Installing Portainer on Manager Server

#### Step 0: Install Docker and Docker Compose
I'm going to install Portainer as a Docker container, and to do so,
I'm assuming you have installed Docker & Docker Compose first.

#### Step 1: Install Portainer via Docker
I prefer to launch the installation of Portainer via `docker-compose`,
use the following `docker-compose.yml` file:

>**NOTE:** If you are installing Portainer on a Synology,
>See the subsection below titled "Installing Docker & Portainer on Synology".

```yaml
---

version: '3'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    ports:
      - 9000:9000
      - 9443:9443
    networks:
      - agent_network
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

networks:
  agent_network:
    driver: overlay
    attachable: true

volumes:
  portainer_data:         # data is stored in /var/lib/docker/volumes
```

To do the install, execute the following on the commandline:

```bash
# start the docker container
sudo docker-compose --file ./portainer-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs portainer

# check if portainer is running
sudo docker ps -a -s
```

Now using your browser, log into Portainer via this URL: `localhost:9000`.

#### Step X: Do Backup Before Upgrading Portainer
Very first thing to do is create a backup for the Portainer configuration.
Log in as an admin user. From the menu select Settings, then scroll down to the Backup Portainer section. Download backup file is the default option. As an optional step, toggle Password protect on and enter a password to encrypt the backup file.
* [Portainer Documentation: Backing up to a local disk](https://docs.portainer.io/admin/settings#backup-portainer)

You'll make use of this backup when you do your first login to the upgraded Portainer.
Log in as a user that was known by the Portainer that was restored.
* [Portainer Documentation: Restoring from a local file](https://docs.portainer.io/admin/settings#restoring-from-a-local-file)

Next you do the upgrade.

#### Step X: Upgrading Portainer
The use of Docker for installation of Portainer does present a dilemma ... bit of a chicken or egg situation.
One of the nice feature of Portainer is how it make it so easy to update containers,
but when Portainer is itself is a container, how can it update itself?
**Well ... it can't.**
We will have to use Docker directly, and **not** Portainer, to do any updates of Portainer.
On the other hand, updating of the Portainer Agent can be done via Portainer without any concern.

To [upgrade to the latest version of Portainer Server][64],
you must use commandline tools.
To do this manually, you following this simple proccedure:
stop Portainer with Docker, remove the old version of Portainer,
and finally do a new install of Portainer.

See below for the **manual method**:

```bash
# stop and remove the protainer container
sudo docker stop portainer
sudo docker rm portainer

# pull down the latest version of portainer
sudo docker pull portainer/portainer-ce:latest

# reinstall portainer
sudo docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

You may want to also upgrade the Portainer Agent and this must be done seperately:

```bash
# stop and remove the protainer agent container
sudo docker stop portainer_agent
sudo docker rm portainer_agent

# pull nd start the updated version of the image
sudo docker pull portainer/agent:latest
sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent:latest
```

You could put all of the above steps into script.
(Check out the video
"[Pi-Hosted : Upgrading Portainer and Updating Containers Part 6][59]"
for a script to do the above steps)
See below for my version of this **scripted method**:

```bash

```

### Step X: Update Your Docker Container
You can update you Docker containers via the commandline,
but Portainer provides a intuitive browser UI to do the same.
Check out the videos:

* [Use Portainer to update your Docker Containers while they are running. No command line needed][65].
* [How to Update a Docker Container using Portainer](https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/)

## Removing Portainer Images & Containers
If you run into problems, kill Portainer
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill portainer

# remove the container image
sudo docker rmi portainer/portainer-ce

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)



------


# Installing Portainer Agent on Remote Server

#### Step 2: Manage Remote Hosts with Portainer
Portainer Remote Host Management feature, using the Paortain Agent,
exposes the Docker API to your Docker agent network.
This isn't a big concern if your within you own LAN,
but if your remotes are outside your LAN, then you have a security concern.
n my case, I'm exposing my Portainer Agent network only to my LAN.

It is important to secure the Docker daemon socket to prevent unauthorized access
to the Docker daemon and to protect sensitive information that may be exposed through the socket.
To learn how to securely expose the Docker API on a remote server
and connect your Portainer GUI, check out the sources below.

Sources:
* [How to manage multiple Hosts in Portainer?](https://www.youtube.com/watch?v=kKDoPohpiNk&list=RDCMUCZNhwA1B5YqiY1nLzmM0ZRg&index=4)
* [How to Secure Docker's TCP Socket With TLS](https://www.howtogeek.com/devops/how-to-secure-dockers-tcp-socket-with-tls/)
* [Protect the Docker Daemon Socket](https://docs.docker.com/engine/security/protect-access/)
* [Protect the Docker daemon socket](https://www.tutorialspoint.com/protect-the-docker-daemon-socket)

#### Step 2: Portainer Agent Deployment
Use the following Docker commands to deploy the Portainer Agent.
Agents are installed on Docker nodes being managed remotely by Portainer.
The agent is not needed on standalone hosts,
however it does provide additional functionality if used:

I prefer to launch the Portainer Agent via `docker-compose`.
use the following `docker-compose.yml` file:

```yaml
---

version: '3'

services:
  portainer:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - 9001:9001
    networks:
      - agent_network
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/var/lib/docker/volumes

networks:
  agent_network:
    driver: overlay
    attachable: true

volumes:
  portainer_data:         # data is stored in /var/lib/docker/volumes
```

To do the install, execute the following on the commandline:

```bash
# remove the container image
sudo docker rmi portainer/agent

# start the docker container
sudo PORTAINER_PORT=9001 docker-compose --file ./portainer-agent-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs portainer-agent

# check if portainer is running
sudo docker ps -a -s
```

Now using your browser, log into portainer via this URL: `localhost:9000`.
Enter Portainer and navigate to the target machine to
[install Portainer Agent via Portainer][68]:

* Select **Stacks** > **Add stack** > **Web editor**
* name the stack via **Name** "portainer-agent".
* Paste the above YAML script into the **Web editor**.
* Scroll down to the bottom and click the **Deploy the stack** button.

### Step 3: Manage Proxmox Docker Containers via Desktop Portainer
We now want to connect the Proxmox based `docker-containers` so it can be monitored
and managed from my `desktop` Portainer.
This is enabled by the Portainer Agent we install in the previous step.

* To connect your `docker-containers` Portainer Agent,
you do the following on your `desktop` Portainer.
* Select **Environments** from the lefthand menu.
* Select the **Add envirnment** button at top left.
* Select **Agent** and for **Name** enter "pfSense Proxmox",
for **Environment URL** enter `192.168.1.69:9001`
for **Public IP** enter `192.168.1.69:9001`
* Select **Add environment** at the bottom left of the page.

Now if you select **Home** from the left-hand main menu,
you'll see both your local docker containers and the ones on Proxmox where my pfSense is hosted.

Source:

* [Installing Portainer and Portainer Agent - An update to show you an easier way to manage Docker](https://www.youtube.com/watch?v=-LPaWq1_GF0)
* [Add ALL of your Docker Hosts to ONE Portainer Dashboard Using the Portainer Edge Agent](https://www.youtube.com/watch?v=8YmQoQ7gAg8)


-----


# Installing Docker & Portainer Agent on Synology
The Docker installation on Synology must done a little different than a standard Linux box.
The implementation Synology DSM isn't standard Debian Linux,
as you might be lead to believe by pursuing its filesystem.
I suspect Synology DSM places some of the Linux filesystem in memory,
and uses little to no disk space (saving it for its NAS function).

As a result,
when referencing volumes in Docker container,
you can't use the typical Linux path provider in Docker Compose YAML files
or the Docker commandline.
When dealing with Synology DSM,
Docker directories are not located at `/var/lib/docker`, but at `/volumeX/@docker`
(or specifically `/volume1/@docker` in my case).

You can "see" this if you log into your Synology NAS and poke around like so:

```bash
# log into the synology nas
ssh -X admin-jeff@192.168.1.201

# you'll see no refrance to /var/lib/docker
$ ls /volume1
@ActiveBackup  @apphome   @autoupdate        @database  @eaDir     @S2S        @SynoFinder-etc-volume  @USBCopy
@appconf       @appstore  Clonezilla-Images  docker     homes      @sharesnap  @SynoFinder-log         @userpreference
@appdata       @apptemp   @config_backup     @docker    NetBackup  @synoconfd  @tmp                    @webdav

# there is a referance to @docker
$ sudo ls /volume1/@docker
btrfs  buildkit  containerd  containers  image	network  plugins  runtimes  swarm  tmp	trust  volumes
```

>**NOTE:** You'll also see the `/volume1/docker` directory has been created, which is empty.

#### Step 1: Install Docker on Synology
Synology NAS has official support for Docker via a package in its Package Center.

* Open the **Package Center** app from the Synology Web GUI.
Search for docker in Package Center and click on **Docker**,
and then **Install**.
* Select the volume you want to use to install Docker images and volumes.
Click **Apply**.

At this point, Docker should be installed on the Synology NAS.
You should be able to open the Synology Docker app via the **Package Center**
and install it vit the **Install** button.

>**NOTE:** You might be wish to pin the Docker app to the main screen.
>It can be used to install container on the Synology NAS, but frankly,
>I find its UI confusing since its not using typical Docker terminology.

#### Step 2: Install Portainer Agent on Synology
Now we'll install `portain/agent` but we'll do it directly using Docker.
There should be away to do this via the Docker App on Synology,
but in this version of Synology DSM, its too confusing to even try.
I'll follow the procedure in the sources below,
specifically, the web document "[Running portainer agent on Synology NAS][66]"
If you wish to see the Synology way of Docker containers,
>see this web article "[How to use Docker on a Synology NAS][67]".

```bash
# log into the synology nas
ssh -X admin-jeff@192.168.1.201

# run the docker command
sudo docker run -d -p 9001:9001 --name portainer-agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /volume1/@docker/volumes:/var/lib/docker/volumes portainer/agent
```

Sources:

* [How to use Docker on a Synology NAS][67]
* [Running portainer agent on Synology NAS][66]
* [Portainer Edge Agent](https://thehomelab.wiki/books/docker/page/portainer-edge-agent)
* [Connect Portainer to Docker on Synology using the Portainer Edge Agent Fast and Easy](https://www.youtube.com/watch?v=eyZsjs5ktF8&t=5s)

### Step 3: Manage Synology Docker Containers via Desktop Portainer
We now want to connect the Synology NAS based Docker containers so it can be monitored
and managed from my `desktop` Portainer.
This is enabled by the Portainer Agent we install in the previous step.

* To connect your Synology NAS Portainer Agent,
you do the following on your `desktop` Portainer.
* Select **Environments** from the lefthand menu.
* Select the **Add envirnment** button at top left.
* Select **Docker** and click **Start Wizard**.
* Select **Agent**, give it the name `synology-nas`
and **URL** enter `192.168.1.201:9001`
* Click **Connect** at the bottom left of the page.

Now if you select **Home** from the left-hand main menu,
you'll see the addition of the `synology-nas` environment to Portainers list.

Source:

* [Installing Portainer and Portainer Agent - An update to show you an easier way to manage Docker](https://www.youtube.com/watch?v=-LPaWq1_GF0)
* [Add ALL of your Docker Hosts to ONE Portainer Dashboard Using the Portainer Edge Agent](https://www.youtube.com/watch?v=8YmQoQ7gAg8)



[58]:https://docs.docker.com/engine/install/
[59]:https://www.youtube.com/watch?v=q3wKqk8qVS8&list=PL846hFPMqg3jwkxcScD1xw2bKXrJVvarc&index=8
[60]:https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
[61]:https://www.portainer.io/
[62]:https://docs.docker.com/compose/
[63]:https://github.com/docker/compose/releases
[64]:https://docs.portainer.io/v/ce-2.9/admin/upgrade/docker
[65]:https://www.youtube.com/watch?v=Eme2TlR7Z7E
[66]:https://www.tnes.dk/?p=430
[67]:https://www.wundertech.net/how-to-use-docker-on-a-synology-nas/
[68]:https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/
[69]:
[70]:
