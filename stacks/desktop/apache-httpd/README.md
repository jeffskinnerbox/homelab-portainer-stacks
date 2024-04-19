<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.0
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----


When your hosting a website,
using a Docker container to execute the server has [several advantages][01]:

* With Docker, you generally want to run one application or process per container.
Containers take advantage of the ability to create isolated environments.
Each container is assigned its own runtime environment
and every single container receives its own network stack and process space.
* For a complex application,
running multiple containers can provide some aditional security benefits.
By running applications on multiple containers,
each container only has access to the ports and files explicitly exposed by the other container.
* Further on, containers offer a higher level of control on what data and software are installed.
Some malodorous script run in one container, won’t affect any other container.
* Updates are an important security issue.
Running applications in a Docker environment makes the process of updating less painful.

In this Docker Stack,
I'm going to establish a website served by the Apache HTTP server.

Sources:

* [How to Use the Apache httpd Docker Official Image](https://www.docker.com/blog/how-to-use-the-apache-httpd-docker-official-image/)
* [Deploy your website with a Docker Apache httpd container volume](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-to-run-an-Apache-Docker-http-image-with-local-files-example)
* [How to dockerize Apache httpd websites example](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-to-dockerize-Apache-httpd-web-servers)
* [How to use docker-compose with Apache httpd example](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Simple-Apache-docker-compose-example-with-Dockers-httpd-image)

# Apache Web Server - Infrastructure to Support WebPages
The Apache HTTP server is the most widely-used web server in the world.
There are a variety of reasons may choose to install the Apache Web Server.
You can use it for testing HTTP server for testing,
or host your own blog or wiki using static web pages, as I plan to do.

#### Step X: Remove Any Webserver on Port 80
The Docker container we are about to install will be using port 80 to render the webpage
internally for our LAN and port 80 for the external Internet world via a Cloudflare Tunnel.
First, check for and remove any existing Apache instance that might be running on port 80:

```bash
# check if port 80 renders a webpage
google-chrome http://localhost:80

# display all network addresses of the host
# you might want to try each ip address list to see if you render a webpage
$ hostname -I
192.168.1.200 192.168.1.12 172.24.0.1 172.20.0.1 172.19.0.1 172.23.0.1 172.21.0.1 172.29.0.1 172.17.0.1 172.25.0.1 172.22.0.1 172.18.0.1 172.26.0.1
```

If you find a webpage on port 80, remove it.

```bash
# check if the apache webserver is running
whereis apache2

# check and see if there is a webserver on port 80
google-chrome http://localhost:80

# list all packages that are install to find apache2
# for ubuntu, make sure to check both apt & snap
apt list | grep apache2
snap list | grep webserver

# remove the apache webserver
sudo service apache2 stop
sudo apt purge apache2 apache2-utils apache2.2-bin apache2-common
sudo apt autoremove
sudo rm -rf /etc/apache2
```

#### Step X: Start Docker Container Version of Apache Web Server
The Apache HTTP Server Project offers a Docker image.
My Docker Compose file is called `apache-httpd-docker-compose.yaml`.

```yaml
# How to use docker-compose with Apache httpd example - https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Simple-Apache-docker-compose-example-with-Dockers-httpd-image

version: '3.9'

services:
  apache:
    container_name: apache-httpd
    image: httpd:latest
    restart: unless-stopped
    ports:
      - '80:80'
    volumes:
      #- /var/www/html:/usr/local/apache2/htdocs
      - /home/jeff/blogging/output:/usr/local/apache2/htdocs
```

#### Step X: Adjust the Firewall
Before using Apache as an external facing webserver,
it’s necessary to modify the firewall settings to allow outside access to the default web ports.
If you followed the installation process above,
you should have a UFW firewall configured to restrict access to your server.

During installation, Apache registers itself with UFW to provide a few application profiles
that can be used to enable or disable access to Apache through the firewall.
List the `ufw` application profiles by running the following:

```bash
# list the ufw application profiles
$ sudo ufw app list
Available applications:
  Apache
  Apache Full
  Apache Secure
  CUPS
```

There are three profiles available for Apache:

* **Apache:** This profile opens only port 80 (normal, unencrypted web traffic)
* **Apache Full:** This profile opens both port 80 (normal, unencrypted web traffic) and port 443 (TLS/SSL encrypted traffic)
* **Apache Secure:** This profile opens only port 443 (TLS/SSL encrypted traffic)

```bash
# verify the ufw status
# if never used, it should be inactive
# inactive = ufw is turned off and currently not enforcing any rules
$ sudo ufw status
Status: inactive

# establish your profile
$ sudo ufw allow 'Apache'
Rules updated
Rules updated (v6)

# activate ufw
$ sudo ufw enable
Firewall is active and enabled on system startup

# verify the change by checking the status
$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
Apache                     ALLOW       Anywhere
Apache (v6)                ALLOW       Anywhere (v6)
```

#### Step X: Setting Up Virtual Hosts
Apache can run multiple websites on a single server,
each of which can be customized and configured independently.
The basic unit that describes a site or a domain is called a virtual host.
This allows the administrator to use one server to host multiple domains or sites
with a single interface or IP address by using a mechanism.

https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04
https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-16-04

Source:
* [How To Install the Apache Web Server on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04)
* [How To Set Up Apache Virtual Hosts on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-16-04)


-----------


# Protecting the Web Server
Any web service endpoint exposed to the public Internet are particularly susceptible to many attacks by hackers.
In my case, the service is a website, where malicious users and bots
will attempt to break into the site, or shut it down,
by repeatedly sending requests, sometimes at with higher frequency.
I will attempt to mitigate these attacks using [Fail2ban][02]
and [Cloudflare Web Application Firewall (WAF)][03].
These security tools help shutdown malicious attacks on the website.

# Cloudflare Web Application Firewall (WAF)
Cloudflare runs one of the largest networks in the world
and one of their key services is [Distributed Denial-Of-Services (DDOS)][04] attack mitigation
Claudflare can handle most any DDOS attach automatically and without charge,
a policy which Cloudflare calls [Unmetered Mitigation][05].
They also provide a service called [Web Application Firewall (WAF)][06]

Cloudflare appears to provide some basic WAF protection automatically,
but you can provide some custom rules via the Cloudflare UI.
To do so, goto the Cloudflare main menu (left-side of the screen)
and select **Security** > **WAF**.
It is here you can provide some limited set of [custome WAF rules][07].

At this time, I have [addeded one custom rule][08]
(**NOTE:** this is the maximum number of rules for the free plan).
That rule will block IP addresses for 10 seconds that exceeding 150 requests within 10 seconds.
You can add rules via the main menu by selecting
**Security** > **WAF** and select from the tab **Rate limiting rules**.

# Fail2Ban
[Fail2ban][02] can also help protect a web server from brute force and Deny-Of-Services (DOS) attacks.
Instead of monitoring traffic like Cloudflare,
Fail2ban is configured to monitor the logs of a service.
It read the logs file and try to match suspsious patterns to actions to perform.
For example, Fail2ban analyzes the logs of the server and looks for several unsuccessful connection attempts.
It will put in place actions that you will block the IP address or send alert email

>**NOTE:**By default, action will be taken when 3 authentication failures have been detected in 10 minutes,
>and the default ban time is for 10 minutes.
>The default for number of authentication failures necessary to trigger a ban
>is overridden in the SSH portion of the default configuration file
>to allow for 6 failures before the ban takes place.
>This is entirely configurable by the administrator in the `jail.conf` file.

* [How Fail2Ban Works to Protect Services on a Linux Server](https://www.digitalocean.com/community/tutorials/how-fail2ban-works-to-protect-services-on-a-linux-server)
* [Protect Web Servers from DDoS Attacks using Fail2ban](https://sysopstechnix.com/protect-web-servers-from-ddos-attacks-using-fail2ban/)

```bash
# scan all ports (all 65536 ports) on router lan side
$ nmap -p- 192.168.1.1
Starting Nmap 7.80 ( https://nmap.org ) at 2023-03-22 15:16 EDT
Nmap scan report for pfSense.jeffskinnerbox.me (192.168.1.1)
Host is up (0.0032s latency).
Not shown: 65532 filtered ports
PORT    STATE SERVICE
53/tcp  open  domain
80/tcp  open  http
443/tcp open  https

Nmap done: 1 IP address (1 host up) scanned in 202.49 seconds

# get the router's extenal IP address
curl ipecho.net/plain ; echo ""
<ext_ip>

# scan all ports (all 65536 ports) on router - from the internet
$ nmap -p- <ext_ip>
Starting Nmap 7.80 ( https://nmap.org ) at 2023-03-22 15:29 EDT
Nmap scan report for pool-<ext_ip>.clppva.fios.verizon.net (<ext_ip>)
Host is up (0.0013s latency).
Not shown: 65532 filtered ports
PORT    STATE SERVICE
53/tcp  open  domain
80/tcp  open  http
443/tcp open  https

Nmap done: 1 IP address (1 host up) scanned in 197.74 seconds

# scan all ports (all 65536 ports) on cloudflare proxy wan side (aka internet)
$ nmap -Pn <cloudflare_ip>
Starting Nmap 7.80 ( https://nmap.org ) at 2023-03-22 15:45 EDT
Nmap scan report for pool-<cloudflare_ip>.clppva.fios.verizon.net (<cloudflare_ip>)
Host is up.
All 1000 scanned ports on pool-<cloudflare_ip>.clppva.fios.verizon.net (<cloudflare_ip>) are filtered

Nmap done: 1 IP address (1 host up) scanned in 201.45 seconds
```

From these set of IP scans, the only ports open are `53`, `80`, and `443` on the WAN side of my router.
Ports `80` & `433` are used for http/https web services (specifically the pfSense admin UI),
but since I'm using Cloudflare Tunnels for web services, I can close them.
As to port `53`, it must remain open to support DNS services




[01]:https://codeburst.io/the-advantages-of-using-docker-for-web-development-23096c457fad
[02]:https://www.fail2ban.org/wiki/index.php/Main_Page
[03]:https://blog.cloudflare.com/waf-for-everyone/
[04]:https://www.akamai.com/our-thinking/ddos
[05]:https://blog.cloudflare.com/unmetered-mitigation/
[06]:https://blog.cloudflare.com/waf-for-everyone/
[07]:https://developers.cloudflare.com/waf/reference/migration-guides/firewall-rules-to-custom-rules/
[08]:https://developers.cloudflare.com/support/firewall/tools/configuring-cloudflare-rate-limiting/
[09]:
[10]:
[11]:


