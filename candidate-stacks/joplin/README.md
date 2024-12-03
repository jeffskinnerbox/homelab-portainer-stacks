<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      1.0.0
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


-----


[Joplin](https://joplinapp.org/) is an open source note-taking app. Capture your thoughts and securely access them from any device.


[Your New Note-Taking App: Joplin](https://www.youtube.com/watch?v=9QVS9P5PPnI)
[Official Joplin Server Docker Images - joplin/server](https://hub.docker.com/r/joplin/server)
[DB Tech Docer Compose File](https://dbt3ch.com/books/joplin-notes/page/docker-compose)
https://github.com/laurent22/joplin

* [Joplin Server is Awesome - Install Joplin Server Using Docker Compose](https://noted.lol/install-joplin-server-using-docker-compose/)



# Obsidian
* Check out this as an alternative [Use Obsidian (BEST Markdown editor) for note taking and tech docs!](https://www.youtube.com/watch?v=cBzc5r-FNW0)
* https://www.google.com/search?q=Obsidian+docker+image&oq=Obsidian+docker+image&aqs=chrome..69i57j0i22i30i625j69i60.3952j0j4&sourceid=chrome&ie=UTF-8









#### Step 1: Install Joplin & Start
You can launch Joplin via `joplin-docker-compose` in the Docker CLI (aka `docker`), or within Portainer.
The Docker Compose file (called `joplin-docker-compose.yml` in this git hub repository) has the form:

```yaml
version: '3'

services:
    db:
        image: postgres:15
        volumes:
            - joplindb:/var/lib/postgresql/data
        ports:
            - "5432:5432"
        restart: unless-stopped
        environment:
            - POSTGRES_PASSWORD=POSTGRES_PASSWORD
            - POSTGRES_USER=POSTGRES_USER
            - POSTGRES_DB=POSTGRES_DATABASE
    app:
        image: joplin/server:latest
        depends_on:
            - db
        ports:
            - "22300:22300"
        restart: unless-stopped
        environment:
            - APP_PORT=22300
            - APP_BASE_URL=https://yourwebsite.com
            - DB_CLIENT=pg
            - POSTGRES_PASSWORD=POSTGRES_PASSWORD
            - POSTGRES_DATABASE=POSTGRES_DATABASE
            - POSTGRES_USER=POSTGRES_USER
            - POSTGRES_PORT=5432
            - POSTGRES_HOST=db
            - MAILER_ENABLED=1
            - MAILER_HOST=smtp.gmail.com
            - MAILER_PORT=465
            - MAILER_SECURE=1
            - MAILER_AUTH_USER=you@yourdomain.com
            - MAILER_AUTH_PASSWORD=3m@1lPa55w0rD
            - MAILER_NOREPLY_NAME=JoplinServer
            - MAILER_NOREPLY_EMAIL=you@yourdomain.com

volumes:
  joplindb:
```

This Joplin service can be loaded & started with the following:

```bash
# load via the docker-compose file
sudo docker-compose --file ./joplin-docker-compose.yml up -d
```

Alternatively, you could load it via the Docker CLI:

```bash
# alternatively, you could load it via docker
sudo docker run --env-file .env -p 22300:22300 joplin/server:latest
```

Where the environment variables in the `.env` file are:

```
DB_CLIENT=pg
POSTGRES_PASSWORD=POSTGRES_PASSWORD
POSTGRES_DATABASE=POSTGRES_DATABASE
POSTGRES_USER=POSTGRES_USER
POSTGRES_PORT=5432
POSTGRES_HOST=db
```

My preferred alternative is to deploy applications with Portainer Stacks.
A stack is a collection of one or more containers that collectively provide a complete application.
Maintaining applications updates via Stacks is simple
because you have the `docker-compose` file within Portainer.

To use Stacks, do the following:

* Enter Portainer and navigate to my `firewall-router` instance of Portainer.
* Select **Stacks** > **Add stack** > **Web editor**
* name the stack via **Name** "joplin".
* Paste the above YAML script into the **Web editor**.
* Scroll down to the bottom and click the **Deploy the stack** button.

See ["How to Manage Docker Containers with Portainer"][04] for more information.

>**NOTE:** If Guacamole has already been installed within Portainer before,
>you may need to remove the old image within the
>**Images**, **Networks**, and **Volumes**.

##################### REMOVE THE TEXT BETWWEN THESE LINES ######################
#### Step 2: Open Firewall
At this point, you could login to Guacamole and begin to configure it
via `google-chrome 192.168.1.200:22300` but lets configure Cloudflare first.

```bash
# check the status of your firewall
sudo ufw status

# open the port need by joplin
sudo ufw allow 22300

# reload the rules to make sure they are active
sudo ufw reload

# to remove a rule you should use
# sudo ufw status numbered
# sudo ufw delete <NUMBER>
```
##################### REMOVE THE TEXT BETWWEN THESE LINES ######################

#### Step 2 - Configure Cloudflare to Support Guacamole - DONE
I'm using [Cloudflare as my DNS server][10] and [Cloudflare Tunnels][11] for increased protection of my LAN.
To configure Cloudflare to support my home LAN environment,
[login to Cloudflare][12],
and via the left-hand menu,
select **Zero Trust** > **Access** > **Tunnels**.
select **Traffic** > **Cloudflare Tunnel** > **Launch Zero Trust Dashboard** > **Access** > **Tunnels**.

Now select **Create a tunnel** and give the tunnel a name of "guacamole",
and select **Save tunnel**.
You'll get a new token that needs to be give to Portainer's container for Cloudflare daemon (call `cloudflare-daemon`)
and paste it into the container.

Select **Next** on Cloudflare and you need to create a subdomain for the Guacamole application.
I entered "guac" for **Subdomain**, "jeffskinnerbox.me" for **Domain**,
"HTTP" for **Type**, and "192.168.1.204:8194" for **URL**.
Now select **Save guacamole tunnel** at the bottom of the page.

Now go to Portainer and from the left-hand menu, select **Containers** > **cloudflare-daemon**.
Select near the top, **Duplicate/Edit**
Scroll down to **Command** and paste in the token and then select **Deploy the container**.
The container should be restarted with the new token.

#### Step X: Accessing Joplin Server (First Time)
Using a web browser, visit your subdomain to the Joplin server.
Gain access by entering `http://desktop:22300` into the browser.

Log in to the Joplin server with the following default email and password.

```
Email: admin@localhost
Password: admin
```

* Click your username, **Admin**, in the top right corner.
* Edit your Administrator profile by filling in the **Full name, Email, and Password** fields.
To ensure Joplin server security, enter a strong, hard-to-guess password and click **Update Profile**.
* Click **Admin** on the main top bar navigation menu.
* Navigate to **Users**, then click **Add user** to set up a new non-administrative account to sync with your Joplin Client.
* Complete the user form and click **Create user** to save the new account.

#### Step X:
#### Step X:
#### Step X:
#### Step X:








#### Step 3: Create New Guacamole Admin login - DONE
We are now done with Cloudflare and time to move back to Guacamole.

Make sure to remove the default username and password and create a new one.
To do this, goto the menu in the top-right corner and select **Settings** >
**Users** > **New User**.

Now add you information and time zone.
Most important is to make sure to give yourself **ALL** the privileges in **Permissions** section
so your are not locked out.

Now logout and then log back in, using the new account you created.
Goto the top right-hand menu and select **Settings** > **Users** > **New User**
and select the `guacadmin` account and disable it.
Now do all you administrative work for Guacamole via this new login.

#### Step 4: Guacamole Two Factor Authentication (2FA) via Cloudflare Tunnels - DONE
Guacamole, as currently implemented above,
provides no secuirty protection other than login/password.
Given that I plan to used Guacamole outside my home LAN, this isn't very safe.
Guacamole does provide extentions to support Two Factor Authentication (2FA)
but I prefer to use Cloudflare's Access controls.
This [video][08] provide a good tutoral on using Cloudflare Access to protect your Guacamole remote gatway.

#### Step 5: Create New Guacamole Admin login - DONE
We are now done with Cloudflare and time to move back to Guacamole.

Make sure to remove the default Guacamole username and password and create a new one.
To do this, goto the menu in the top-right corner and select **Settings** >
**Users** > **New User**.

Now add you information and time zone.
Most important is to make sure to give yourself **ALL** the privileges in **Permissions** section
so your are not locked out.

Now logout and then log back in, using the new account you created.
Goto **Settings** > **Users** > **New User**
and select the `guacadmin` account and disable it.
Now do all you administrative work for Guacamole via this new login.

#### Step 5: Create a Guacamole Connection - DONE
Goto the top right-hand menu and select **Settings** > **Connections**.
Click the button **New Connections**.
Enter the following information
(**NOTE:** many of the fields will be defaulted and left blank):

|       Server Name        | Protocol |     Hostname    |  Port  | User | Password |
|:------------------------:|:--------:|:---------------:|:------:|:----:|:--------:|
| desktop (jeff via shell) |   SSH    |  192.168.1.200  |   22   | xxxx | xxxxxxxx |
| pve-1 (root via shell)   |   SSH    |  192.168.1.204  |   22   | xxxx | xxxxxxxx |
| desktop (jeff via VNC)   |   VNC    |  192.168.1.200  |  5900  | xxxx | xxxxxxxx |

Now go back to menu at the top right and select **Home**.
Select you connection and you should be logged in,
**except for the VNC connection**.
In this case, the VNC client must be running on the target machine
and we'll install that next.


-----


# Install Virtual Network Computing (VNC)
I want to remote desktop into Linux so I can take full advantage of the the desktop GUI menu system.
There are in fact [many remote desktop software packages][32] available to choose from,
but only small number seem to have any following in the Linux world,
and VNC is the de-facto remote desktop protocol for Linux.
[Virtual Network Computing (VNC)][39] uses the RFB (“remote framebuffer”) open protocol.
Because it works at the [framebuffer][32] level, it is applicable to all windowing systems and applications,
including Microsoft Windows, MacOS and the X Window System.
Linux X Window System has its own remote desktop tool, [Xephyr][33],
which allows you to nest X server within a X server (aka "X Nesting").
Cleaver but insecure, little used, an only available on X Window systems
(my experimentation with Xephyr can be found [here][34]).
There are other posibilities for accessing desktops remotely,
such as the [Remote Desktop Protocol (RDP)][42].
This is a proprietary protocol developed by Microsoft,
which provides a user with a graphical interface to
connect to another computer over a network connection.

Because of its popularity, VNC seems like the right choose of protocol.
The [VNC client/server model][38]
moves the whole video frame from the server to the VNCViewer on the client,
which give you a true representation of the remote desktop.
Contrast this with a popular alternative to VNC, that being Windows Remote Desktop (WRD).
WRD does not transport frames, thereby reducing the bandwidth requirements (good),
but instead must create its own separate user session / rendering of the GUI experience (not so good).

There are [multiple instance of VNC implementation][37].
[RealVNC][35] appears to be [supported by Raspberry Pi Raspian OS][36],
on the other hand, [x11vnc][44] seems well tuned for X Windows,
and [TightVNC][39] comes installed within many Linux full distribution package.
But what is the [best VNC][40] ... could it be a useless question?
Just to keep it simple and consistent, I choose to [install TightVNC on my Ubuntu][41] system.

In my user scenario for VNC,
my Ubuntu desktop will be running the VNC client so it can run the remote Linux desktop in one of its window.
Therefore, my remote Linux will be configured as a VNC server.
We need to make sure VNCserver software is installed already on remote and configured as needed.

Sources:
* [How to use Apache Guacamole to create a VNC Connection](https://www.howtoforge.com/how-to-use-apache-guacamole-to-create-a-vnc-connection)
* [How to Install and Use Apache Guacamole Remote Desktop on Rocky Linux 8](https://www.howtoforge.com/how-to-install-and-use-apache-guacamole-remote-desktop-on-rocky-linux-8/)
* [Install Apache Guacamole for SSH and VNC over HTML5](https://leandeep.com/install-apache-guacamole-for-ssh-and-vnc-over-html5/)


-----


## Update Your Docker Container
You can update you Docker containers via the commandline,
but Portainer provides a intuitive browser UI to do the same.
Check out these videos:

* [Use Portainer to update your Docker Containers while they are running. No command line needed](https://www.youtube.com/watch?v=Eme2TlR7Z7E)
* [How to Update a Docker Container using Portainer](https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/)

## Removing Guacamole Images & Containers
If you run into problems, kill Guacamole container
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# get the container id
sudo docker ps -a -s

# kill the container
sudo docker kill guacamole

# remove the container
sudo docker rm <Container_ID>

# optional: run the following command to remove the container forcefully
sudo docker rm -f <Container_ID>

# remove the container image
sudo docker rmi abesnier/guacamole

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)



[01]:https://guacamole.apache.org/
[02]:https://guacamole.apache.org/api-documentation/
[03]:https://guacamole.apache.org/doc/gug/
[04]:https://sweetcode.io/how-to-manage-docker-containers-with-portainer/
[05]:https://tomcat.apache.org/
[06]:https://www.postgresql.org/
[07]:https://github.com/just-containers/s6-overlay
[08]:https://www.youtube.com/watch?v=DGw6P5Lkj-U&t=2060s
[09]:
[10]:https://www.cloudflare.com/dns/
[11]:https://www.cloudflare.com/products/tunnel/
[12]:https://dash.cloudflare.com/login

[32]:https://en.wikipedia.org/wiki/Framebuffer
[33]:https://nims11.wordpress.com/2012/06/24/nested-x-servers-with-xephyr/
[34]:http://jeffskinnerbox.me/posts/2014/Apr/29/howto-using-xephyr-to-create-a-new-display-in-a-window/
[35]:https://www.realvnc.com/en/
[36]:https://www.raspberrypi.org/documentation/remote-access/vnc/
[37]:https://www.lifewire.com/vnc-free-software-downloads-818116
[38]:https://www.lifewire.com/vnc-virtual-network-computing-818104
[39]:https://www.tightvnc.com/
[40]:https://www.techradar.com/news/5-of-the-best-linux-remote-desktop-clients
[41]:https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-16-04
[42]:https://en.wikipedia.org/wiki/Remote_Desktop_Protocol


