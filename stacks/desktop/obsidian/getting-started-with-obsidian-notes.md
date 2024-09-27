<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->

<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>

---------------



download snap container from <https://snapcraft.io/obsidian>




# Getting Started with Obsidian Notes
Obsidian is available as a [cross-platform app][01],
meaning it works on all the major operating systems—Windows, Mac, and Linux.
Obsidian also has a [mobile apps][02] for both iOS and Android.
Obsidian is free for personal use but for commercial purposes,
then there is a [yearly fee][03].
[Obsidian Sync][04] allows you to sync your notes (for a fee) between your devices.

Sources:

* [Getting Started with Obsidian Notes: A Beginner’s Guide](https://obsidian.rocks/getting-started-with-obsidian-a-beginners-guide/)
* [Obsidian Quick Start Guide (2024)](https://www.youtube.com/watch?v=KWf3tnQkY2Y)
* [How to Install Obsidian Using LinuxServer Image on Your Synology NAS](https://mariushosting.com/how-to-install-obsidian-using-linuxserver-image-on-your-synology-nas/)


#### Step 1: Download and Install Obsidian
For me, the Linux instance is what I need, and you can get it [here][05],
but in my case, I preferred to make load Obsidian as a Docker container.

As of 03/2023, there doesn't appear to be an official Docker image for Obsidian
but there is a popular [community supported Docker image][07] on [GitHub][08],
with the image accessible via [GitHub Packages][06].
This repositories `README.md` file covers how to do the Docker install of Obsidian.


#### Step 2: Create a Vault
Once Obsidian is downloaded and installed, open the app.
The first thing it will ask you is to Create a new vault.
Click the purple button and give you test version or vault a name and a location.

In my case using a Docker container,
I specified this information with the Docker Compose file I used.


#### Step x


#### Step x


#### Step x


#### Step x


#### Step x


#### Step x


#### Step x



[01]:https://obsidian.md/download
[02]:https://obsidian.md/mobile
[03]:https://obsidian.md/pricing
[04]:https://obsidian.md/sync
[05]:https://obsidian.md/
[06]:https://github.com/features/packages
[07]:https://forum.obsidian.md/t/obsidian-remote-running-obsidian-in-docker-with-browser-based-access/34312
[08]:https://github.com/sytone/obsidian-remote
