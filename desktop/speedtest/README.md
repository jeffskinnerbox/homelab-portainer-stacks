<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


* [Internet SpeedTest Tracker on Docker - 2022 Edition](https://www.youtube.com/watch?v=feArak6WCLw)
* [Speedtest Tracker](https://docs.speedtest-tracker.dev/)


* [How to Setup InfluxDB, Telegraf and Grafana on Docker: Part 1](https://thenewstack.io/how-to-setup-influxdb-telegraf-and-grafana-on-docker-part-1/)
* [How to Setup InfluxDB, Telegraf and Grafana on Docker: Part 2](https://thenewstack.io/how-to-setup-influxdb-telegraf-and-grafana-on-docker-part-2/)
* [How To Install InfluxDB Telegraf and Grafana on Docker](https://www.junosnotes.com/devops/how-to-install-influxdb-telegraf-and-grafana-on-docker/)
* [Running InfluxDB 2.0 and Telegraf Using Docker](https://www.influxdata.com/blog/running-influxdb-2-0-and-telegraf-using-docker/)



# IPerf3
Installing an iPerf3 Docker container so you can test your network hardware
to make sure you're getting what you've been told you're getting.

## Network Perfromance Testing with Docker IPerf3
* [Test Your Networking Gear with an iPerf Server in Docker](https://www.youtube.com/watch?v=iYB99BF7erg)

## Synology iPerf3 Speed Test
* [How to Run a Speed Test on a Synology NAS with iPerf3](https://www.wundertech.net/run-a-speed-test-on-a-synology-nas-with-iperf3/)






# SpeedTest
With this utility, you can check your Internet bandwidth using the
[Speedtest website][01] (really you are using the [Speedtest CLI][02])
via three Docker container.
You can configure the tool to run periodically
and test results are save to an InfluxDB database
and use Grafana for graphics visualization.

Sources:

* [Docker Speedtest Grafana is a clean graphical representation of your internet speeds over time](https://www.youtube.com/watch?v=qn_Bw9pE0vs)
* [frdmn / speedtest-grafana](https://hub.docker.com/r/frdmn/speedtest-grafana)
* [frdmn / docker-speedtest-grafana](https://github.com/frdmn/docker-speedtest-grafana)

# Install Speedtest
This Docker setup consists of a Grafana pre-configured dashboard, InfluxDB database,
and a speedtest.net CLI test runner.

```bash
# clone the frdmn/docker-speedtest-grafana repository
cd ~/src/docker-containers
git clone https://github.com/frdmn/docker-speedtest-grafana speedtest
cd speedtest

# create a copy of the sample .env file and adjust s you wish
cp .env.sample .env
```

I prefer to launch Speedtest via `docker-compose`,
using the following file:

```yaml
# place this in file speedtest-docker-compose.yml
version: '3'
services:
  influxdb:
    image: influxdb:1.8
    container_name: influxdb
    restart: always
    ports:
      - 8083:8083
      - 8086:8086
    volumes:
      - ./influxdb/:/var/lib/influxdb
    environment:
      - INFLUXDB_ADMIN_USER=admin
      - INFLUXDB_ADMIN_PASSWORD=password
      - INFLUXDB_DB=speedtest

  grafana:
    image: grafana/grafana:6.7.2
    container_name: grafana
    restart: always
    volumes:
      - ./docker/grafana/provisioning/:/etc/grafana/provisioning
    ports:
      - ${GRAFANA_PORT}:3000               # port used for grafana graphics
    environment:
      - GF_SERVER_ROOT_URL=http://localhost
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_AUTH_ANONYMOUS_ENABLED=true
    depends_on:
      - influxdb

  speedtest:
    image: frdmn/speedtest-grafana:latest
    container_name: speedtest
    restart: always
    environment:
      - SPEEDTEST_INTERVAL=${SPEEDTEST_SPEEDTEST_INTERVAL}
      - SPEEDTEST_HOST=local
    depends_on:
      - influxdb
```

To do the install, execute the following commandline:

```bash
# install & start the docker container
sudo GRAFANA_PORT=3000 SPEEDTEST_SPEEDTEST_INTERVAL=300 docker-compose --file ./speedtest-docker-compose.yml up -d
```

To service the application, once installed, use the following commands:

```bash
# stop service once installed
sudo docker-compose stop

# start service once installed
sudo docker-compose --file ./speedtest-docker-compose.yml start

# upgrade service one installed
sudo docker-compose stop
sudo docker-compose pull
sudo docker-compose rm
sudo docker-compose up -d

# check logs
sudo docker-compose logs -f
sudo docker-compose logs -f grafana
```

## Removing Netdata Images & Containers
If you run into problems, kill the Homer dashboard
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill netdata

# remove the container image
sudo docker rmi netdata/netdata

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune

# to remove any speedtest volumes
rm -r -f /home/jeff/src/docker-volumes/speedtest
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)



[01]:https://www.speedtest.net/
[02]:https://www.speedtest.net/apps/cli
[03]:
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:
