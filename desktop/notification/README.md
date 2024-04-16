<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


* Setup notifications from ...
    * Synology NAS  - [How To Enable Synology NAS Pushover Notifications](https://www.youtube.com/watch?v=XP-eM3SauUY)
    * Rsync backup - [Send Push Notifications To Your Phone In Python With Pushover API](https://www.youtube.com/watch?v=2RHqWr6QWHc)
    * Leesburg Water Usage Report - [Best Notification System for Home Servers with Apprise Push Alerts][11]
    * Pi.Alert -
    * CloudFlare -
    * Internet Connection - [https://www.techtutorials.tv/tags/monitoring/](https://www.techtutorials.tv/tags/monitoring/)
    * Watchtower -
    * Wyze Doorbell Camera -
    * Home Assistant - [SETUP APPRISE NOTIFICATIONS ON HOME ASSISTANT](https://nuxref.com/2020/12/15/setup-apprise-notifications-on-home-assistant/)
* Setup notifications to ...
    * Pushover -
    * Slack - [Setup A Notification System For Labs And Home Networks](https://www.techtutorials.tv/sections/management-and-monitoring/setup-a-notification-system-for-labs-and-home-networks/)
    * Scrolling Billboard -



When I developed my [Rysyc + Snapshot system backup procedure][03],
I choose a push notification scheme, using a mobile app (i.e. Pushover),
to notify me of success or failure of those backups.
I didn't want to load up email with these status messages,
I just wanted a quick & simple message for me to review on my mobile phone.
Unfortunately, many devices, applications, and cloud services use email instead for notifications.
I want a single notification scheme for my homelab envirnment.

My homelab's notification service is a combination of [Pushover][04], [Apprise][01], and [Mailrise][02]:

* **Pushover** is an Android, iPhone & iPad, or Desktop Browser clients that receive
unlimited real-time push notifications from dozens of websites, services, and applications that already integrate with Pushover.
In short, it is your notifications user experience on your mobile phone, browser app, etc.
* **Apprise** allows you to send a notification to almost all of the most popular notification services available
(e.g. Pushover, Telegram, Discord, Slack, Amazon SNS, Gotify, etc.)
In short, it is a gateway to all your notifications apps.
* **Mailrise** is an SMTP server that converts the emails it receives into Apprise notifications.
In short, it is a SMTP gateway for Apprise notifications.

>**NOTE:** You may be tempted to setup your own mail server.
>Most people will advise you not to do so.
>See [here][09] and [here][10].

Sources:

* [Best Notification System for Home Servers with Apprise Push Alerts][11]
* [Setup A Notification System For Labs And Home Networks](https://www.techtutorials.tv/sections/management-and-monitoring/setup-a-notification-system-for-labs-and-home-networks/)
* [How To Setup A Notification System For Labs And Home Networks][07]
* [Get Instant Push Notifications with Zero Subscription Fee!][08] - DONE

# Install Notification Server
I combined the two installations steps below into a single Docker Compose Stack
file called `docker-compose-notification.yml`.

## Install & Configure Apprise

Sources:
* [Best Notification System for Home Servers with Apprise Push Alerts][11]
* [Apprise](https://r4ven.fr/en/blog/apprise-opensource-notification-library/)

#### Step 1: Install Apprise
Apprise allows you to send a notification to almost all of the most popular notification
services available to us today such as: Pushover, Telegram, Discord, Slack, Amazon SNS, Gotify, etc.
Apprise provides a small built-in Configuration Manager,
that can be optionally accessed through your web browser,
allowing you to create & save as many configurations as you'd like.
This configuration management is performed via a browser on an expposed port.

To install Apprise, do the following:

```yaml
# to launch only apprise via docker-compose, place this in file apprise-docker-compose.yml
version: '3.8'

services:
  apprise:
    image: caronc/apprise:latest
    container_name: apprise
    ports:
      - '8005:8000'
    restart: unless-stopped
    volumes:
      - /home/jeff/src/docker-containers/notification-server/apprise.conf:/config
```

Enter the above Docker Compose script into Portainer and start the container.
The Appire exposed port `8005` and this API provides a simple gateway to directly access it via an HTTP interface
via `http://localhost:8005/cfg/apprise`.

#### Step 2: Config Directory Permissions
Within the container, the configuration file's user (and group) is `www-data` which generally has the `id` of `33`.
If the container is run under `root`,
you will get the error: _An error occurred saving configuration_.
Apprise documentation suggests [three methods to fix this][12].

I choose the quick & dirty way since I don't antcipating making many changes in the future.
The quick why is to just set the directory with full read/write permissions inside the container.
Grant full permission to the local directory you're saving your Apprise configuration.

See [DockerHub: caronc/apprise - Config Directory Permissions](https://hub.docker.com/r/caronc/apprise)
for a better procedure.

```bash
# login as root (aka '-u 0' in the command below) to the container
sudo docker exec -it -u 0 apprise /usr/bin/bash

# list the configuration of the configruation directory
$ ls -l / | grep config
drwxr-xr-x   2 root     root        4096 Feb 16 20:32 config

# change the permissions on the configuration directory
chmod 777 /config

# make you updates to the apprise configuration via browser access of http://localhost:8005/cfg/apprise
# enter pover://<user>@<token> where <user> and <token> are taken from pushover site


# change the permissions to their orginal state
chmod go-w /config
```

## Install & Configure Mailrise

Sources:
* [Best Notification System for Home Servers with Apprise Push Alerts][11]
* [How To Setup A Notification System For Labs And Home Networks][07]
* [How To Configure Authentication and Encryption for Mailrise SMTP Gateway](https://www.youtube.com/watch?v=GowmYRZHUW4)

#### Step 2: Install Mailrise
Mailrise is an SMTP server that converts the emails it receives into Apprise notifications.
Mailrise enables Linux servers, Internet of Things devices, surveillance systems,
and outdated software to gain access to the full suite of 60+ notification services supported by Apprise.

Mailrise also makes email notifications more secure and reliable.
Compared to a conventional SMTP server, it's more secure (no need to leave your email password on a device)
and no email service provider's spam filters blocking you messages.

To install Mailrise,
Copy the contents of `mailrise.conf` in this repository to the volume location
as specified by your Docker Compose file give below.
Next, enter the Docker Compose script below into Portainer and start the container.

```yaml
# launch only mailrise via docker-compose, place this in file mailrise-docker-compose.yml
version: '3.8'

services:
  mailrise:
    image: yoryan/mailrise:latest
    container_name: mailrise
    ports:
      - '8025:8025'
    restart: unless-stopped
    volumes:
      - /home/jeff/src/docker-containers/notification-server/mailrise.conf:/etc/mailrise.conf
```


--------


# Usage of Notification Service
/path/to/daily-job.sh && apprise "Daily Job succeded" || apprise "Daily job failed"

Test Apprise ...

```bash
# see apprise api - http://localhost:8005/cfg/apprise
# see 'Persistent Storage Solution' - https://hub.docker.com/r/caronc/apprise

# sends notification to all of the end points you've configured associated with a key = 'apprise'
curl -X POST \
    -F "title=Test Title #5" \            # optional - title to go along with the message body
    -F "body=Test Message #5" \           # required - your message body
    -F "type=info" \                      # optional - valid message types are 'info', 'success', 'warning', and 'failure', default is 'info'
    -F "format=text" \                    # optional - valid data formats are 'text', 'markdown', 'html', default is 'text'
    -F "tags=all" \                       # optional -
    http://localhost:8005/notify/apprise

curl -X POST -F "title=Test Title #5" -F "body=Test Message #5" -F "type=info" -F "format=text" -F "tags=all" http://localhost:8005/notify/apprise

# returns the apprise configuration from the persistent store associated with a key = 'apprise'
curl -X POST http://localhost:8005/get/apprise
```

Test Mailrise ...
* at 11:03 time - [How To Setup A Notification System For Labs And Home Networks][07]

* [How To Configure Authentication and Encryption for Mailrise SMTP Gateway](https://www.techtutorials.tv/sections/management-and-monitoring/configure-authentication-and-encryption-for-mailrise/)
* [How to Use the Gmail SMTP Server to Send Emails for Free](https://kinsta.com/blog/gmail-smtp-server/)
* [Sending Emails With Python](https://realpython.com/python-send-email/)

```
telnet localhost 8025
                                   Trying 127.0.0.1...
                                   Connected to localhost.
                                   Escape character is '^]'.
                                   220 52ded48ed8fb Mailrise 0.0.post1.dev1+gee40be5
HELO homelab.local
                                   250 52ded48ed8fb
mail from:admin@homelab.local
                                   250 OK
rcpt to:slack@mailrise.xyz
                                   250 OK
data
                                   354 End data with <CR><LF>.<CR><LF>
from: admin@homelab.local
subject: Linux Test
Test Message
.
                                   250 OK
quit
                                   221 Bye
                                   Connection closed by foreign host.
```


--------


# Install Your Notification Clients

#### Step 1: Install Pushover - DONE
The primary user experience client I depend on for notifications is Pushover on my Andriod mobile phone.
The installation is simple and provided by [Google Play][05]
and follow the Youtube video ["Get Instant Push Notifications with Zero Subscription Fee!"][08].

Give that Apprise supports many clients concerently,
I'm going to install another client, specifically Slack.

Sources:
* [Get Instant Push Notifications with Zero Subscription Fee!][08].

#### Step 2: Install Slack
I also want these notifications sent to [Slack][06] for when I'm browsing the web or working
and may not be near my mobile phone.
To do the Slack install, I basically followed the Youtube video by [Tech Tutorials - David McKone][07].

This will allow Mailrise to send messages directly to Slack (**that is**, not through Apprise):

* All communication concerning my Home Lab, create workspace titled **Home Lab** on [Slack](https://app.slack.com/)
* For all alerts & notifications for my Home Lab, create a channel titled **alerts-notifications**
* For Mailrise to communicate its alerts to Slack, create an **App** on [Slack](https://api.slack.com/apps)
* For you App you need to create a **Bot** by selecting the box, select **Review Scopes to Add**, select **Add OAuth Scope**, select **chat:write** (send message as mailrise)
* On the left-hand menu, select **Install App**, select **Install Workspace**, select **Allow**
* Copy the Bot User OAuth Token (You can get this token later from the left-hand menu at **OAuth & Peermissions**)
* Now you want to add your Bot to your channel. Goto your **Home Lab** workspace & **alerts-notifications** channel.
Enter into the message `@mailrise` and hit return.  You be prompted to add this person and select **Add to Channel**.
You now have the Bot supporting Mailrise added to the channel.




Sources:
* [How To Setup A Notification System For Labs And Home Networks][07]

--------


# Install Mail Tools
* [Send email from Linux: 2023 Guide with Code Examples](https://mailtrap.io/blog/linux-send-email/)
* [5 Efficient Ways to Send Emails from the Linux Command-Line](https://tecadmin.net/ways-to-send-email-from-linux-command-line/)
* [Send Email in Linux from Command Line](https://www.digitalocean.com/community/tutorials/send-email-linux-command-line)



------


# Removing Images & Containers
If you run into problems, kill the Homer dashboard
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill homer

# remove the container
sudo docker rm homer

# remove the container image
sudo docker rmi b4bz/homer

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

# Homer Color Scheme
You can create a well matched color palette scheme with the site [Coolors](https://coolors.co/).

# Homer Icons
You can find icons suitable for the Homer dashboard at the following sites:

* [Homer Icons](https://github.com/NX211/homer-icons)
* [Font Awesome](https://fontawesome.com/start)

```bash
# move to the icons directory
cd ~/src/docker-containers/homer/assets/icons

# download the icon
wget https://raw.githubusercontent.com/NX211/homer-icons/master/png/pfsense.png
```



---------



# Testing
`pushoverTest.py` taken from https://github.com/AdamGetbags/pushoverApp/blob/main/pushoverTest.py
and see [Send Push Notifications To Your Phone In Python With Pushover API](https://www.youtube.com/watch?v=2RHqWr6QWHc)

* [Sending EMAILS with PYTHON: 5 minute tutorial](https://www.youtube.com/watch?v=ueqZ7RL8zxM)
* [How to Send Emails with Python - New Method 2023](https://www.youtube.com/watch?v=g_j6ILT-X0k)
* [How To Send Email In Python | Smtplib Tutorial](https://www.youtube.com/watch?v=S465v4mWsRg)
* [AMT2 - Extracting Emails from your Gmail Inbox using python](https://www.youtube.com/watch?v=K21BSZPFIjQ)



[01]:https://hub.docker.com/r/caronc/apprise
[02]:https://github.com/YoRyan/mailrise
[03]:/home/jeff/blogging/content/articles/network-backups-via-rsync-and-rsnapshot.md
[04]:https://pushover.net/
[05]:https://play.google.com/store/apps/details?id=net.superblock.pushover
[06]:https://slack.com/
[07]:https://www.youtube.com/watch?v=WdhhIZmnmaI
[08]:https://www.youtube.com/watch?v=z_e39lmd5b4
[09]:https://www.youtube.com/watch?v=Q-E6ljN3eG0
[10]:https://www.youtube.com/watch?v=Nj8tTAGrUKE
[11]:https://www.youtube.com/watch?v=Cj7A46NuACA
[12]:https://github.com/caronc/apprise-api?tab=readme-ov-file#config-directory-permissions
[13]:
[14]:
[15]:
[16]:
[17]:
[18]:
[19]:
[20]:

