<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->

<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>

---------------


# Building a Second Brain

* [Building a Second Brain: The Definitive Introductory Guide](https://fortelabs.com/blog/basboverview/)
* [Building A Second Brain: Ways to Maximize Your Digital Life](https://clickup.com/blog/building-a-second-brain/)
* [Building a Second Brain](https://maggiewang.org/writing/building-a-second-brain/)

* [How I Put My Mind Under Version Control](https://medium.com/analytics-vidhya/how-i-put-my-mind-under-version-control-24caea37b8a5)
* [Building a USEFUL Dashboard in Obsidian](https://www.youtube.com/watch?v=AatZl1Z_n-g)
* [Mastering Obsidian](https://www.youtube.com/watch?v=ctetnQfSdfM&list=PL7oLu8NfQd84_gsyqBVSVgUmCCgcvSZMx)
* [Productivity Power Hour](https://www.youtube.com/playlist?list=PLdW65tjm2FbYSQrIdSfPIELCtXwKclnuv)


## The Zettelkasten Method

* [The Zettelkasten Method: A Beginner's Guide](https://www.goodnotes.com/blog/zettelkasten-method)
* [Getting Things Done](https://gettingthingsdone.com/)
* [Zettelkasten Method](https://zettelkasten.de/overview/)
    * [Zettelkasten for technical learning](https://www.youtube.com/watch?v=eNACvn_pfAE)
    * [Zettelkasten for programmers](https://www.youtube.com/watch?v=z9IgFRAVV9w&t=0s)


## Products in the Market

* [Test-Driving a New Generation of Second Brain Apps: Obsidian, Tana, and Mem](https://fortelabs.com/blog/test-driving-a-new-generation-of-second-brain-apps-obsidian-tana-and-mem/)
* [10 BeSetting Up A Second Brain — A Personal Docs Storyst Second Brain Apps for Note-Taking in 2024](https://clickup.com/blog/second-brain-apps/)
* [Setting Up A Second Brain — A Personal Docs Story](https://medium.com/age-of-awareness/setting-up-a-second-brain-a-personal-docs-story-59089cf72c64)

---------------


## Obsidian Intrduction

* [Hack your brain with Obsidian.md](https://www.youtube.com/watch?v=DbsAQSIKQXk)
* [You're not stupid: How to learn difficult things with Obsidian](https://www.youtube.com/watch?v=QXIa0NAycGo)
* [How to get started with Obsidian in 2022 - from scratch!](https://www.youtube.com/watch?v=OUrOfIqvGS4)
* [Form, Function, & Fun! - My Obsidian Vault Tour](https://www.youtube.com/watch?v=rAkerV8rlow)

* [Obsidian: The King of Learning Tools (FULL GUIDE + SETUP)](https://www.youtube.com/watch?v=hSTy_BInQs8)
* [Mastering Obsidian](https://www.youtube.com/playlist?list=PL7oLu8NfQd84_gsyqBVSVgUmCCgcvSZMx)
* [Top 5 Obsidian Plugins ESSENTIALS for Beginners](https://www.youtube.com/watch?v=8uBMjAoE--I)

* [Publishing Platform for Obsidian](https://obsidian.md/publish)


## Obsidian Canvas

* [Obsidian Canvas](https://www.youtube.com/watch?v=vLBd_ADeKIw)
* [How I’m ACTUALLY Using The Obsidian Canvas](https://www.youtube.com/watch?v=HFK3D7zeyTA)


## Text Generator Plugin / GPT-3.5

* [How I'm Using AI WITH My Obsidian Vault](https://www.youtube.com/watch?v=tNAsLbGdM6A)


## Obsidian Plugins

* [You all NEED these Obsidian community plugins](https://www.youtube.com/watch?v=Yzi1o-BH6QQ)


## ExcaliBrain Obsidian Plugin

* [How to use the ExcaliBrain Obsidian plugin](https://www.youtube.com/watch?v=gqEtn3gCZF0)
* [ExcaliBrain is transforming how I use Obsidian.md](https://www.youtube.com/watch?v=gOkniMkDPyM)

* [Mind Maps In Obsidian, Make Them Faster and Better - MarkMind Plugin](https://www.youtube.com/watch?v=fMq0aoAjueE)
* [Breadcrumbs - Everything you need to know](https://www.youtube.com/watch?v=N4QmszBRu9I)

---------------


## Obsidian

[Obsidian][04] is a knowledge base and note-taking software application
that operates on Markdown files.
It is designed to help users organize and structure their thoughts
and knowledge in a flexible, non-linear way.

With Obsidian, your data sits in a local folder.
The format of the text data is Markdown, making human readable, easily conerted to HTML,
directly editable, supported by many editor ... its future-proof!
Obsidian can work completely offline,
so Internet service issues will never be your problem.

Sources:

* [Use Obsidian (BEST Markdown editor) for note taking and tech docs!](https://www.youtube.com/watch?v=cBzc5r-FNW0)
* [Obsidian Remote: Running Obsidian in docker with browser-based access][02]
* [Obsidian Help](https://help.obsidian.md/Obsidian/Index)
* [Discord: Obsidian Members Group (OMG)](https://discord.com/invite/obsidianmd)
* [Obsidian Plugins](https://obsidian.md/plugins)


## Install Obsidian

As of 03/2023, there doesn't appear to be an offical Docker image for Obsidian
but this is a popular [communitiy supported Docker image][02] on [GitHub][03],
with the image accessable via [GitHub Packages][01].

```bash
# launch obsidian container via docker on commandline
docker run -d \
  -v /home/jeff/src/docker-volumes/obsidian/vaults:/vaults \
  -v /home/jeff/src/docker-volumes/obsidian/config:/config \
  -p 8081:8080 \
  -e DOCKER_MODS=linuxserver/mods:universal-git \
  --name="obsidian" \
  --restart=unless-stopped \
  ghcr.io/sytone/obsidian-remote:latest
```

If you prefer to launch Obsidian via `docker-compose`, use the following
(**NOTE:** To get your UID & GID, execute `id` in a terminal):

```yaml
# launch obsidian via docker-compose - place this in file obsidian-docker-compose.yml
version: '3.8'
services:
  obsidian:
    image: 'ghcr.io/sytone/obsidian-remote:latest'
    container_name: obsidian
    restart: unless-stopped
    ports:
      - ${OBSIDIAN_PORT}:8080
    volumes:
      - ${OBSIDIAN_HOME}/vaults:/vaults
      - ${OBSIDIAN_HOME}/config:/config
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - DOCKER_MODS=linuxserver/mods:universal-git
```

To start Obsidian container via `docker-compose`,
use the following command:

```bash
# start the docker container via
sudo OBSIDIAN_PORT=8081 OBSIDIAN_HOME='/home/jeff/src/docker-volumes/obsidian' docker-compose --file ./obsidian-docker-compose.yml up -d

# check for any errors during the install via
sudo docker logs obsidian
```


## Removing Images & Containers

If you run into problems,
kill Obsidian and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill obsidian

# remove the container
sudo docker rm obsidian

# remove the container image
sudo docker rmi ghcr.io/sytone/obsidian-remote

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune

# to remove any obsidian volumes
rm -r -f /home/jeff/src/docker-volumes/obsidian
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

---------------


## Configuring Obsidian

* [A beginner's guide to using the Obsidian Notes application](https://www.marclittlemore.com/beginners-guide-note-taking-obsidian/#what-are-obsidian-backlinks)
* [Mastering Obsidian](https://www.youtube.com/watch?v=ctetnQfSdfM&list=PL7oLu8NfQd84_gsyqBVSVgUmCCgcvSZMx)

[01]:https://github.com/features/packages
[02]:https://forum.obsidian.md/t/obsidian-remote-running-obsidian-in-docker-with-browser-based-access/34312
[03]:https://github.com/sytone/obsidian-remote
[04]:https://obsidian.md/
