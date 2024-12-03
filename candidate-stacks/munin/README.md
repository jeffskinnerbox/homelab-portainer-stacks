<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


* [Munin in Docker](https://geek-cookbook.funkypenguin.co.nz/recipes/munin/)

[Munin][01] is a web based tool to monitor system and network statistic. Munin shows this information through Graphs.

Munin is a networked resource monitoring tool that can help analyze resource trends and "what just happened to kill our performance?" problems. It is designed to be very plug and play. A default installation provides a lot of graphs with almost no work.


# Munin on the Master Host
Note: apache2-utils is required for the htpasswd program to be installed.

```bash
# install apache web server
sudo apt-get install apache2 apache2-utils

# test if apache is up and running
//http:/localhost:80
```

By default, installing the munin package, installs both the munin master process (which collects data) and the munin-node.
Run the following command to verify that munin-node is active on your master host:

```bash
# install munin
sudo apt-get install munin

# verify that munin-node is active on your master host
$ ps ax | grep munin
```

https://nsrc.org/workshops/2015/rwnog/raw-attachment/wiki/Track2Agenda/exercise1-munin.htm
https://github.com/geerlingguy/ansible-role-munin



# Munin Tutorals
* [Installing Munin](http://guide.munin-monitoring.org/en/latest/installation/install.html)
    * [Tutorial](http://guide.munin-monitoring.org/en/latest/tutorial/index.html)
    * [munin-node-configure](http://guide.munin-monitoring.org/en/latest/reference/munin-node-configure.html)
    * [munin.conf](http://guide.munin-monitoring.org/en/latest/reference/munin.conf.html)
* [How To Install the Munin Monitoring Tool on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-install-the-munin-monitoring-tool-on-ubuntu-14-04)
* [Server Monitoring with Munin and Monit on Ubuntu 16.04 LTS (Xenial Xerus)](https://www.howtoforge.com/tutorial/server-monitoring-with-munin-and-monit-on-ubuntu-16-04-lts/)
* [How To Install munin-plugins-core on Ubuntu 22.04](https://installati.one/ubuntu/22.04/munin-plugins-core/)
* [How To Install Munin on Ubuntu 20.04 LTS](https://idroot.us/install-munin-ubuntu-20-04/)
* [How To Install munin-node-c on Ubuntu 22.04](https://installati.one/ubuntu/22.04/munin-node-c/)
* [Installing Munin on Ubuntu 20.04 with MySQL plugin](https://www.thesysadmin.rocks/2020/06/24/installing-munin-on-ubuntu-20-04-with-mysql-plugin/)
* [How to make Munin periodically remind you of unresolved alerts](https://willbryant.net/how_to_make_munin_periodically_remind_you_of_unresolved_alerts)

# Docker Version
aheimsbakk/munin-alpine - https://hub.docker.com/r/aheimsbakk/munin-alpine



[01]:https://munin-monitoring.org/
[02]:
[03]:
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
