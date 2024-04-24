<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# MyMedia for Alexa
I like to play music from my computer library stream it to my Amazon Echo (aka Alexa).
To do this, I choose to use [My Media for Alexa][01].
It cost only $5.50/year, and [My Media Alexa Skill][02].
Installation instructions are in [video][03] on the [myMedia homepage][04].

You have two methods of doing an install of MyMedia:
Docker and Ubuntu package manager.
My preferred method is via Docker.

## Install MyMeda for Alexa via Docker
You find the install methodology documented [here][05] and is shown below.

```yaml
# place this in file mymedia-docker-compose.yml
version: "3"
services:
  app:
    image: 'bizmodeller/mymediaforalexa:latest'
    container_name: 'mymedia-alexa'
    restart: unless-stopped
    ports:
      - 52050:52050
      - 52051:52051
    volumes:
      - ${LIB}/Music:/medialibrary
      - ${LIB}/.MyMediaforAlexa:/datadir
```

Execute the Docker Compose file via:

```bash
# start the docker container
sudo LIB='/home/jeff' docker-compose --file ./mymedia-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs MyMediaforAlexa
```

Alternatively you could use Docker directly via:

```bash
# install mymedia via docker
sudo docker run -d \
    --name="mymedia-alexa" \
    -p 52050:52050 -p 52051:52051 \
    -v ~/Music:/medialibrary \
    -v ~/.MyMediaforAlexa:/datadir \
    --restart=always \
    bizmodeller/mymediaforalexa:latest
```

----

## MyMedia is Silent
When you ask Alexa to play music from My Media,
there might be just silence.
There can be several reason for this
(more can be found [here][07]).
Check the actions below to clear the problem.

### Check Device are on Same Network
Your Alexa device must on the same network as the computer running the My Media server software.
If this is not the case, goto the **Settings** menu
and choose one of the options (specifically **Listening IP Address**
to allow your media to be streamed via the Internet.

If your computer has multiple network connections (check with `hostname -I`),
then check that My Media has automatically picked the IP address
that's in the same network as the Alexa device.
If it has not, you can override this IP address in **Settings**
(this must be the IP address of the computer running the My Media server).

In my case,
I went to **http:\\localhost:52051** > **Settings** > **Listening IP Address**
and added `192.168.1.200`.

### Check Computer Firewall
If your computer is running a software firewall (e.g. [`ufw`][06]),
then you must have a rule configured to allow inbound TCP network connections
on port 52050 and 52051.

In my case, I did the following:

```bash
# turn on ufw
sudo ufw enable

# open the required port
sudo ufw allow 52050
sudo ufw deny 52051
#sudo ufw allow 52051

# check ufw status
sudo ufw status verbose
```

>**NOTE:** The My Media for Alexa installation program will automatically create
>these rule for some firewalls like `iptables` but not `ufw`.

----

## Removing Images & Containers
If you run into problems, kill MyMediaforAlexa
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill/stop the container
sudo docker kill mymedia-alexa

# remove the container
sudo docker rm mymedia-alexa

# remove the container image
sudo docker rmi bizmodeller/mymediaforalexa

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune

# to remove any mymedia-alexa volumes
rm -r -f /home/jeff/src/docker-volumes/mymedia-alexa
```

Finally, we remove the My Media index files

```bash
# find the name of the mymedia package
$ apt list --installed | grep mymedia
mymedia/now 1.3.147.994 amd64 [installed,local]

# completely remove the my media package install
sudo apt-get remove --purge mymedia/now

# remove the mymedia index files
rm -r -f ~/.mymedia-alexa

# do a complete clean the cache of old/outdated packages
sudo apt-get clean

# remove orphaned or unnecessary dependencies
sudo apt-get autoremove
```


Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)



[01]:http://mymediaalexa.com/
[02]:https://www.amazon.com/bizmodeller-My-Media/dp/B06XPP135L
[03]:https://www.youtube.com/watch?v=Pv4Aw5-ONy0
[04]:http://mymediaalexa.com/
[05]:https://www.mymediaalexa.com/home/docker#download
[06]:https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-20-04
[07]:https://www.mymediaalexa.com/#section-10
