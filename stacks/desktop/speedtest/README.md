<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->

<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>

---------------


# Speedtest Tracker

Speedtest Tracker is a self-hosted internet performance tracking application
that runs speedtest checks against Ookla's Speedtest service.
The main use case for Speedtest Tracker is to build a history
of your Internet's performance so that you can be informed
when you're not receiving your ISP's advertised rates.

Speedtest Tracker uses [Ookla's Speedtest service][04] using
[Laravel][05] and the [Speedtest CLI][06] for testing.
You can setup a periodic testing schedule by specifing
the frequency the testing is performed.
You can find documentation how you can configure Speedtest Tracker
via its [documentation website][07]
and the [DockerHub site][08].

It appears that the [original version of Speedtest Tracker][01] was abandoned.
This version of Speedtest Tracker ([GitHub: alexjustesen/speedtest-tracker][02])
is supported and packaged to run via a Docker container expects one of these
database servers to be installed: SQLite, MariaDB/MySQL or, Postgres.
[Linuxserver.io][03] has taken Speedtest Tracker a step further by packaging
it with a database to maintain historical information, etc.

Sources:

* [How to install Speedtest Tracker 2 on Portainer](https://www.youtube.com/watch?v=n7uLTrv3FmQ)
    * [How to install Speedtest Tracker on Portainer](https://www.youtube.com/watch?v=9FK7F_cVWEU)
* [Speedtest Tracker](https://docs.speedtest-tracker.dev/)
* [GitHub: alexjustesen/speedtest-tracker](https://github.com/alexjustesen/speedtest-tracker)
* [Internet SpeedTest Tracker on Docker - 2022 Edition](https://www.youtube.com/watch?v=feArak6WCLw)
* [Homelab Series - Creating a SpeedTest Tracker Server](https://www.youtube.com/watch?v=MJOvWNIIZnk)


---------------


## Installation of Speedtest Tracker

These stps will show you how to use `docker-compose` via `portainer`
to install Speedtest Tracker.


#### Step 1: Choose a Database

Speedtest Tracker requires a database and supports several.
I have a choosen the [MairaDB][09] database for my solution.


#### Step 2: Quick Test of Speedtest Tracker

To get going quickly, you can use the script below.
Documentation for the parameters required can be found in the [Parameter section][08] of the documentation.
The `APP_KEY` is used for encrypting stored data and you can generate a key at `https://speedtest-tracker.dev`.

```bash
sudo docker compose up --detach
```

The above command should use the `docker-compose.yml` file listed below:

```yaml
---

services:
  speedtest-tracker:
    container_name: speedtest-tracker
    image: lscr.io/linuxserver/speedtest-tracker:latest
    restart: unless-stopped
    ports:
      - 8083:80
      - 8084:443
    environment:
      - PUID=1000
      - PGID=1000
      - APP_KEY="base64:mEDEbug0rP/f49ASZKQKJqA1ZKyN06SY65hXDgYJsP0="   # generate a key at `https://speedtest-tracker.dev`
      - DB_CONNECTION=mysql
      - DB_HOST=db
      - DB_PORT=3306
      - DB_DATABASE=speedtest_tracker
      - DB_USERNAME=speedy
      - DB_PASSWORD=password
      - SPEEDTEST_SCHEDULE="*/5 * * * *"    # run speedtest every 5 minutes
      - PRUNE_RESULTS_OLDER_THAN=30         # after 30 days, remove speedtest data from database
      - APP_TIMEZONE="America/New_York"     # your location time zone
    volumes:
      - ~/src/homelab-portainer-stacks/stacks/desktop/speedtest/data:/config
      - ~/src/homelab-portainer-stacks/stacks/desktop/speedtest/data/keys:/config/keys
    depends_on:
      - db

  db:
    container_name: mariadb
    image: mariadb:10
    restart: always
    environment:
      - MARIADB_DATABASE=speedtest_tracker
      - MARIADB_USER=speedy
      - MARIADB_PASSWORD=password
      - MARIADB_RANDOM_ROOT_PASSWORD=true
    volumes:
      - speedtest-db:/var/lib/mysql

volumes:
  speedtest-db:                             # database is stored in /var/lib/docker/volumes
```


#### Step 3: Login to Speedtest Tracker

Once the Speedtest Tracker container starts,
you can login into it via a browser with URL `locahost:8083`.
Use the following default credentals to do the login:
**Username =** `admin@example.com`, **Password =** `password`.

Speedtest Tracker is a self-hosted Internet performance tracking application
using Ookla's Speedtest service.
To get a list of the Ookla sites, execute the command below:

```bash
# to get a list of nearby Ookla's Speedtest servers
sudo docker exec speedtest-tracker php /app/www/artisan app:ookla-list-servers
```


#### Step X: Update Your Docker Container

You can install you Docker containers via the `docker`
and `docker compose` commandline tools,
but Portainer provides a intuitive browser UI to do the same
using the `docker-compose.yml` file stoed in GitHub.
To use this approach, you need to add the following to Portainer:

* **Name** `speedtest-tracker`
* **Repository URL** `https://github.com/jeffskinnerbox/homelab-portainer-stacks`
* **Repository reference** ``
* **Compose path** `stacks/desktop/speedtest/docker-compose.yml`

For more information, check out these videos:

* [Use Portainer to update your Docker Containers while they are running. No command line needed](https://www.youtube.com/watch?v=Eme2TlR7Z7E)
* [How to Update a Docker Container using Portainer](https://www.wundertech.net/how-to-update-a-docker-container-using-portainer/)


---------------


## Removing Speedtest Tracker Images & Containers

If you run into problems, kill the running Speedtest Tracker
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# log into the docker container and check out its operational status
sudo docker exec -it speedtest bash

# kill the container
sudo docker kill speedtest

# remove the container image
sudo docker rmi aceberg/speedtest

# list any dangling images
sudo docker images -f dangling=true
```

This final step you **may not** want to perform.
It will delete the configuration and database record files
you have created via Speedtest Tracker.
At a minimum, you might want to create a copy of the data files.

```bash
# copy or trash Speedtest Tracker's persistent data files
sudo cp ~/src/homelab-portainer-stacks/stacks/desktop/speedtest/data ~/tmp/speedtest/data

# remove or trash Speedtest Tracker's persistent data files
sudo trash ~/src/homelab-portainer-stacks/stacks/desktop/speedtest/data
sudo rm -f -r ~/src/homelab-portainer-stacks/stacks/desktop/speedtest/data
```

Another clean up step you **may no** want to perform is of dangling and unreferenced
unused containers, networks, images.

```bash
# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

[01]:https://github.com/henrywhitaker3/Speedtest-Tracker
[02]:https://github.com/alexjustesen/speedtest-tracker
[03]:https://www.linuxserver.io/
[04]:https://www.speedtest.net/
[05]:https://laravel.com/
[06]:https://www.speedtest.net/apps/cli
[07]:https://docs.speedtest-tracker.dev/
[08]:https://hub.docker.com/r/linuxserver/speedtest-tracker
[09]:https://mariadb.org/
