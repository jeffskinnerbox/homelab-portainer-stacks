<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="http://www.foxbyrd.com/wp-content/uploads/2018/02/file-4.jpg" title="These materials require additional work and are not ready for general use." align="center">
</div>


----


# Nginx Proxy Manager
[Nginx Proxy Manager][01] is the go-to tool to establish a reverse proxy.
Using Docker, I'm going to describe how to install Nginx as a proxy manager.
Alternatively, you can use a already established reverse proxy if it exists.


Sources:

* [Proxy vs. Reverse Proxy (Explained by Example)](https://www.youtube.com/watch?v=ozhe__GdWC8)
* [How to Setup a Reverse Proxy on Home Network](https://www.youtube.com/watch?v=QcnAqN_Ihqk)
* [Docker and Running your self-hosted applications in a more secure way behind a reverse proxy.](https://www.youtube.com/watch?v=8T68pB_Fkm4)
* [Nginx Proxy Manager - How-To Installation and Configuration](https://www.youtube.com/watch?v=P3imFC7GSr0&t=129s)

* [How To Install Nginx Proxy Manager in Docker on Ubuntu 20.04](https://smarthomepursuits.com/how-to-install-nginx-proxy-manager-in-docker/)
* [What is Nginx | easy way](https://www.youtube.com/watch?v=WuH0T9FHDZ4)
* [NGINX Linux Server | Common Configurations](https://www.youtube.com/watch?v=MP3Wm9dtHSQ)
* [Nginx Proxy Manager - How-To Installation and Configuration](https://www.youtube.com/watch?v=P3imFC7GSr0)
* [Proxy vs reverse proxy vs load balancer (2020) | Explained with real life examples](https://www.youtube.com/watch?v=MiqrArNSxSM)
* [Reverse proxy nginx letsencrypt tutorial](https://www.youtube.com/watch?v=DyXl4c2XN-o)
* [Reverse proxy with NGINX and letsencrypt tutorial](https://www.the-digital-life.com/nginx-reverse-proxy/)
* [create short local URLs for your internal self-hosted services](https://www.youtube.com/watch?v=6aaSjwJhOog)

## Install Nginx Proxy Manager (NPM)

#### Step 1: Install Nginx Reverse Proxy Manager Containe
We'll use `docker-compose` to create the Nginx Proxy Manager container.
We need to create a folder where our Nginx `config.json` and `docker-compose` files will exist.
You will have to provide the database server yourself.
Your options are MySQL or MariaDB databases and I choose to use MariaDB.

```bash
# directory for configuration files
cd ~/src/docker-containers
mkdir nginx-proxy-mgr
cd nginx-proxy-mgr
```

You can create your container using `docker-compose` by creating the confguration file `nginx-proxy-mgr-docker-compose.yml`.
Here is an example of what your `nginx-proxy-mgr-docker-compose.yml` when using a MariaDB container:

```yaml
version: "3"
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: nginx-proxy-mgr
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - ${ADMIN_PORT}:81      # admin web port
      - ${HTTP_PORT}:80       # public http port
      - ${HTTPS_PORT}:443     # public https port
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "npm"
      DB_MYSQL_NAME: "npm"
      # DISABLE_IPV6: 'true'  # uncomment this if IPv6 is not enabled on your host
    volumes:
      - ${NPM_HOME}/data:/data
      - ${NPM_HOME}/letsencrypt:/etc/letsencrypt
      - ${NPM_HOME}/letsencrypt/log:/var/log/letsencrypt
    depends_on:
      - db
  db:
    image: 'jc21/mariadb-aria:latest'
    container_name: mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: 'npm'
      MYSQL_DATABASE: 'npm'
      MYSQL_USER: 'npm'
      MYSQL_PASSWORD: 'npm'
    volumes:
      - ${NPM_HOME}/data/mysql:/var/lib/mysql
```

Run the command below to download and install all the necessary files,
and then start the docker container:

 ```bash
 # start the docker container
sudo ADMIN_PORT=8081 HTTP_PORT=9080 HTTPS_PORT=9443 NPM_HOME='/home/jeff/src/docker-containers/nginx-proxy-mgr' docker-compose --file ./nginx-proxy-mgr-docker-compose.yml up -d
 ```

#### Step 2: Login and Update Admin Account
When the Nginx Proxy Manager is running for the first time,
the following will happen:

* The database will initialize with table structures
* GPG keys will be generated and saved in the configuration file
* A default admin user will be created

This process can take a couple of minutes depending on your machine.

Within a browser,
navigate to the IP address of your Linux box and port 81: `http://localhost:81`.

```bash
# within npm's host, login to nginx proxy manager default admin account
google-chrome http://localhost:81
```

The default email address is `admin@example.com` and the password is `changeme`.
When you log in, you should change this information.

At this point, Nginx Proxy Manager is fully installed.
You will need to open ports 80/443 on your router to point to your Nginx Proxy Manager.
From there, you will have to configure Nginx Proxy Manager.

Sources:
* [NginX Proxy Manager is a free, open source, GUI for the NginX Reverse Proxy making it easy to use.](https://www.youtube.com/watch?v=RBVcnxTiIL0&t=470s)
* [Super Simple Cloudflare and Nginx Proxy Manager Setup Using YOUR Domain](https://www.youtube.com/watch?v=cI17WMKtntA&t=13s)
* [NGINX PROXY MANAGER TUTORIAL DUCKDNS CONFIGURATION](https://www.youtube.com/watch?v=wrMn8sar-nA)
* [INSTALLING A CLOUDFLARE DOCKER ON A RASPBERRY PI 4 DDNS](https://www.youtube.com/watch?v=8W0wKz8rSog)
* [How to Setup and Configure a Reverse Proxy on unRAID with LetsEncrypt & NGINX](https://www.youtube.com/watch?app=desktop&v=I0lhZc25Sro)

## Removing Images & Containers
If you run into problems, kill the Homer dashboard
and clean-up any unused resources
(i.e. images, containers, volumes, and networks)
that are dangling (not tagged or associated with a container).
This is shown below:

```bash
# kill the container
sudo docker kill nginx-proxy-mgr mariadb

# remove the container
sudo docker rm nginx-proxy-mgr mariadb

# remove the container image
sudo docker rmi jc21/nginx-proxy-manager jc21/mariadb-aria

# remove the volumes
sudo rm -rf data/ letsencrypt/

# list any dangling images
sudo docker images -f dangling=true

# removes all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
sudo docker system prune
```

Source:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)



[01]:https://nginxproxymanager.com/
