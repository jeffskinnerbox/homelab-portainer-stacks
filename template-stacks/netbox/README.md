
* [Using NetBox for Ansible Source of Truth](https://www.ansible.com/blog/using-netbox-for-ansible-source-of-truth)

* [NetBox Ansible Collection: Installation](https://josh-v.com/netbox_ansible_collection/collection_install/)

* [Netbox as your Source of Truth for Ansible, Systems, and your Network - April 16, 2020](https://www.youtube.com/watch?v=GyQf5F0gr3w)


# Alternative
* [Homebox](https://hay-kot.github.io/homebox/)
* [Homebox - Open Source, Self hosted Inventory and Asset Management for your home or small business!](https://www.youtube.com/watch?v=XawMT0fg_To)







* [NetBox](https://github.com/netbox-community/netbox)
* [NetBox.dev](https://netbox.dev/about/)

The more you getting into network automation, and the larger your infrastructure,
the bigger the pain in the ass it is to write scripts for your entire inventory.
If you’re familiar with Ansible, you’re familiar with the concept of separating your inventory
from your core code or configuration management.
You write your configurations in one place,
and then you identify your inventory that it applies to in a different place.
The idea being that you can identify your inventory one time, usually in a YAML file

So where does Netbox come into play? Netbox is inventory management, without YAML files.
When we set up our inventory in Netbox,
you can now integrate Netbox with other applications.
In fact, there is a [Netbox inventory driver specifically for Ansible](https://docs.ansible.com/ansible/latest/collections/netbox/netbox/nb_inventory_inventory.html).

# Netbox Installation
to get Netbox up and operational,
I basicly followed the procedures outline in the sources below.
I did make some changes because I ran into problems (e.g. I install the very latest version of DOcker).

Sources:
* [What is NetBox - FREE Network Documentation System?](https://www.youtube.com/watch?v=jr9Pxx0NkTc&list=RDCMUC05NSijsZpNM_mbd0-qagLA&start_radio=1)
* [Installing NetBox 10 minutes! WHAAAAAT?!?](https://www.youtube.com/watch?v=uHMXZpXpDvc)
* [GitHub: netbox-community / netbox-docker](https://github.com/netbox-community/netbox-docker)
* [How to deploy the Netbox network documentation/management tool with Docker](https://www.techrepublic.com/article/how-to-deploy-the-netbox-network-documentationmanagement-tool-with-docker/)

### Step 2: Installing Docker - DONE
To install Docker manually, go to the [Docker installation page][58].
There are multiple methods but I'm using the recommend method using [Docker’s repositories][60].

`docker-compose` is a separate binary from `docker`,
and it too is best downloaded directly from the project’s GitHub releases.
Head to [Docker Compose’s releases page][63] and take note of the latest version number.

Source:
* [Docker explained simply](https://www.youtube.com/watch?v=_trJf3GbZXg&list=RDCMUCZNhwA1B5YqiY1nLzmM0ZRg&index=2)
* [How To Install and Use Docker on Ubuntu 20.04](https://phoenixnap.com/kb/install-docker-on-ubuntu-20-04)

```bash
# check the currently install verson of docker
docker --version

# uninstall any old version of docker (called docker, docker.io, or docker-engine)
apt remove docker docker-engine docker.io containerd runc

# update the apt package index and install packages
apt update
apt install apt-transport-https ca-certificates curl gnupg lsb-release

# add docker’s official gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# set up the stable repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

# install the latest version of docker engine
apt update
apt install docker-ce docker-ce-cli containerd.io
```

This setup relies on `docker` and `docker-compose` meeting the requirements:
`docker` version 19.03 or greater
and `docker-compose` version 1.28.0 or greater.

```bash
# install a specific version of docker engine, list the available versions in the repo
$ apt-cache madison docker-ce
 docker-ce | 5:20.10.12~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.11~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.10~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.9~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.8~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.7~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.6~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.5~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.4~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.3~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
 docker-ce | 5:20.10.2~3-0~ubuntu-focal | https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
   .
   .

# install a specific version using the version string from the second column
# sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
apt install docker-ce=5:20.10.12~3-0~ubuntu-focal docker-ce-cli=5:20.10.12~3-0~ubuntu-focal containerd.io

# check the currently install version of docker
$ docker --version
Docker version 20.10.12, build e91ed57
```

Now lets install `docker-compose`.
At the time of writing, the latest version of `docker-compose` was 1.29.2.

```bash
# download the latest version of docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# make the file executable
chmod +x /usr/local/bin/docker-compose

# check docker-compose status
$ docker-compose --version
docker-compose version 1.29.2, build 5becea4c
```



----




## Install Portainer
Adopting container orchestration platforms like Kubernetes can be hard.
[Portainer][12] is a popular Docker UI that helps you visualise your
containers, images, volumes and networks.
Portainer helps you centrally configure, manage and secure containerized environments,
regardless of where they are hosted.
It helps you take control of the Docker resources on your machine, avoiding lengthy terminal commands.

You can the Portainer install via the Ansible playbook `portainer-install.yaml`.

To test the installation

```bash
google-chrome http://192.168.33.10:9000
google-chrome localhost:9000
```

Sources:
* [Portainer, a free, open source, self-hosted Web GUI for your Docker Instances - Local and Remote!](https://www.youtube.com/watch?v=d_yCqZIui80)

#### Step 1: Portainer Server Deployment - DONE
Use the following Docker commands to deploy the Portainer Server.

```bash
# create the volume for storing persistent data
sudo docker volume create portainer_data

# install the portainer container
# ports 8000 is for agents, and 9000 for http web ui, 9443 for https web ui
#sudo docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# check if portainer is running
sudo docker ps -a -s
```

Now using your browser, log into `portainer` via this URL: `http://localhost:9000`:
username is `admin` and the password is `changeme`.

```bash
# start portainer in your browser
google-chrome http://localhost:9000
```

At this time, you can clean-up your `hello-world` Docker test above by deleting its container.

#### Step 2: Portainer Agent Deployment - DONE
We have installed Portainer on the headless Ubuntu VM but I would like to mange it
locally via my Linux desktop instance of Portainer.
This will give me a integrated, single screen to manage my distributed Docker environment.
You do this via an Portainer agent on the VM communicating with the Desktop Portainer.

Use the following Docker commands to [deploy the Portainer Agent][41].
Agents are installed on Docker nodes being managed remotely by Portainer.
The agent is not needed on standalone hosts,
however it does provide additional functionality if used:

```bash
# install the portainer agent container
sudo docker run -d -p 9001:9001 --name portainer-agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent
```

Allow the Portainer Agent container to install and start running.
The do the following on you master Portainer instance
(For detail instruction, see the [27 minutes mark in this video][09]):

1. Then from your Portainer browser for you master (aka Portainer instance on your Desktop Linux)
navigate in the left pane to **Environments**.
2. Click the **+ Add environment** button at the top of the screen
3. Select the **Agent** box and then on the **Name** field giving it a name (e.g. Bitwarden).
4. On the **Environment URL** enter the IP address and port
(from the Vagrantfile you get the IP address `192.168.33.10`, enter `192.168.33.10:9001`)
5. Enter the same information within the **Public IP** fields.
6. click the **+ Add environment** button at the bottom of the form.

#### Step 3: Update Portainer - DONE
When needed, you can update all containers via the Portainer UI, with one exception.
You can't update the Portainer Docker container.

To update Portainer to its latest version, you do the following:

```bash
# stop the portainer container and then remove it
sudo docker stop portainer && sudo docker rm portainer

# pull the latest portainer image
sudo docker pull portainer/portainer-ce:latest

# deploy the newest version of Portainer
# ports 8000 is for agents, and 9000 for http web ui, 9443 for https web ui
#sudo docker run -d  -p 8000:8000 -p 9000:9000 -p 9443:9443 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
sudo docker run -d  -p 8000:8000 -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

#### Step 4: Update Your Docker Container - DONE
You can update you Docker containers via the commandline,
but Portainer provides a intuitive browser UI to do the same.
Check out the video ["Use Portainer to update your Docker Containers while they are running. No command line needed."][40].



----





### Step X: Install Netbox - DONE
Container within a container!

```bash
# go to roots home directory
cd ~/src/docker-containers/netbox

# download the dockere version of netbox
git clone -b release https://github.com/netbox-community/netbox-docker.git

# chand to your working directory
cd netbox-docker

# create your docker-compose file
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 7000:8080
EOF

# create the docker container
# this may take a while, depending on your internet connection
sudo docker-compose pull
```

### Step X: Start Netbox - DONE
In this final step,
you'll see a lot of output on your screen.
NetBox will be initializing the database and then start.

```bash
# start the netbox container
# 'sudo docker-compose up' doesn't seem to work
sudo docker-compose up -d
```

It will take around two to five minutes before Netbox becomes available.
During that time, issue the command:

```bash
# is netbox running and on what port
echo "http://$(docker-compose port netbox 8080)/"
```

The above command will print out the URL you should use to access Netbox
(most likely `http://0.0.0.0:7000/` but `http://localhost:9000` also works, place this in a web browser).
You should see the NetBox homepage.
On the top-right corner you can login.

The default credentials are:

* Username: admin
* Password: admin
* API Token: 0123456789abcdef0123456789abcdef01234567





[58]:https://docs.docker.com/engine/install/
[59]:
[60]:https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

[63]:https://github.com/docker/compose/releases

[12]:https://www.portainer.io/
[41]:https://docs.portainer.io/v/ce-2.9/admin/environments/add/docker
[09]:https://shownotes.opensourceisawesome.com/installing-portainer/
[40]:https://www.youtube.com/watch?v=Eme2TlR7Z7E

