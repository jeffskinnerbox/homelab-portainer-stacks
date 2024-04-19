<!--
Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
Version:      0.0.1
-->


<div align="center">
<img src="https://raw.githubusercontent.com/jeffskinnerbox/blog/main/content/images/banners-bkgrds/work-in-progress.jpg" title="These materials require additional work and are not ready for general use." align="center" width=420px height=219px>
</div>


----



* [Using Docker and Docker Compose for Local Development and Small Deployments](https://www.codementor.io/@jquacinella/docker-and-docker-compose-for-local-development-and-small-deployments-ph4p434gb#How-Can-We-Publish-This-)
* [How To Build and Deploy a Flask Application Using Docker on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-build-and-deploy-a-flask-application-using-docker-on-ubuntu-18-04)
* [Build and Deploy a Flask Application Using Docker](https://dzone.com/articles/build-deploy-flask-application-using-docker)


* [Alpine Docker Container](https://hub.docker.com/_/alpine)
* [Building Docker Image from Scratch](https://dockerlabs.collabnix.com/beginners/building-docker-image-from-scratch.html)
* [How to build Your First Alpine Docker Image and Push it to DockerHub](https://dockerlabs.collabnix.com/beginners/building-your-first-alpine-container.html)
* [How to Build Docker Image : Comprehensive Beginners Guide](https://devopscube.com/build-docker-image/)
* [How to Deploy Microservices with Docker](https://www.linode.com/docs/guides/deploying-microservices-with-docker/)
* [Getting started with Microservices and Docker](https://www.coditation.com/blog/getting-started-with-microservices-and-docker)
* [Build and Deploy a REST API Microservice with Python Flask and Docker](https://dev.to/swarnimwalavalkar/build-and-deploy-a-rest-api-microservice-with-python-flask-and-docker-5c2d)
* [BUILD MICROSERVICE ARCHITECTURE (MSA) REST API USING THE USING FLASK](https://www.topcoder.com/thrive/articles/build-microservice-architecture-msa-rest-api-using-the-using-flask)
* [Microservices in Python using Flask Framework | Dockerize and Deploy to Kubernetes with Helm](https://www.youtube.com/watch?v=SdTzwYmsgoU)


[Flask][01] is a micro-web framework written in Python.
It is classified as a microframework because it does not require particular tools or libraries.
It has no database abstraction layer, form validation,
or any other components where pre-existing third-party libraries provide these common functions.

Frameworks like Flask come with a library of modules and functions with which you can create backend systems for your own web applications. It helps you to create custom endpoints that serve (respond to) the requests from the front-end of your website without having to worry about the lower-level implementations of thread management, data transfer protocols, etc.

Some features which make Flask an ideal framework for web application development are:

* Flask provides a development server and a debugger
* Flask uses Jinja2 templates
* Flask is WSGI 1.0. compliant
* Flask provides integrated support for unit testing
* Flask has many extensions available for enhancing its existing functionalities

Sources:

* [Build and Deploy a Flask Application Using Docker](https://dzone.com/articles/build-deploy-flask-application-using-docker)
* [Microservices in Python using Flask Framework | Dockerize and Deploy to Kubernetes with Helm](https://www.youtube.com/watch?v=SdTzwYmsgoU)
* []()

* [Python Flask Tutorial - Getting Started with Flask](https://scoutapm.com/blog/python-flask-tutorial-getting-started-with-flask)
* [How To Make a Web Application Using Flask in Python 3](https://www.digitalocean.com/community/tutorials/how-to-make-a-web-application-using-flask-in-python-3)


# Build and Deploy a Flask Application Using Docker
To start things off,
I'm going to build and deploy a Flask application using Docker on Ubuntu 22.04.
The application will process data stored in a JSON file format and displayed on the browser.

#### Step 1: Create the Dockerfile
Create the `Dockerfile` which contains a list of commands to assemble the desired image:

```
# start with a ubuntu base
FROM ubuntu:22.04

LABEL maintainer="jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me"
LABEL version="0.0.1"

# update and install required linux packages
RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev

# home directory
WORKDIR /app

# copy requirements.txt and install required python packages
COPY ./requirements.txt /app/requirements.txt
RUN pip3 install -r requirements.txt

COPY . /app

CMD [ "python3", "./app.py" ]
```

Create the needed `requirements.txt` file to support the Dockerfile:

```
Flask==2.2.3
```

#### Step 2: Create the Flask Application
Write file called `app.py` containing Python / Flask code
to process a JSON file called `db.json`,
and supply HTML webpage via the `index.html` file.

First is the application file `app.py`:

```python
import os
from flask import Flask, render_template, abort, url_for, json, jsonify
import json

app = Flask(__name__,template_folder='.')

# read file
with open('db.json', 'r') as myfile:
    data = myfile.read()

@app.route("/")
def index():
    return render_template('index.html', title="page", jsonfile=json.dumps(data))


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
```

The `index.html` file render and display data via a browser:

```html
<!DOCTYPE html>
<html>
<body>

<h2>JSON Data</h2>

<p id="demo"></p>

<script>
 var jsonfile ={{ jsonfile|tojson }};
 var obj = JSON.parse(jsonfile);;
document.getElementById("demo").innerHTML = obj;
</script>

</body>
</html>
```

#### Step 3: Create Your Docker Ignore File
The `.dockerignore` file is very similar to the `.gitignore` file in that it
allows you to specify a list of files or directories that Docker
is to ignore during the build process.
This can come in really handy in certain instances, but more importantly,
the `.dockerignore` can help you reduce the size of the image and dramatically speed up the build process.

```
### --------------------------- Project Specific --------------------------- ###


### ------------------------------- General -------------------------------- ###

### Compiler and Linker Files ###
*.pyc
*.com
*.class
*.dll
*.exe
*.o
*.so
*.bin
*.elf

### Packages & Images ###
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

### Git / Unit test / coverage reports ###
logs/
.git
.cache
htmlcov/
.tox/
.coverage
nosetests.xml
coverage.xml

### Ingore all markdown and class files ###
*.md
**/*.class

### Header files containing secrets ###
secret.h
secrets.h
passwords.txt

### Logs & Databases ###
*.log
*.sql
*.sqlite*
*.dblite
.ipynb_checkpoints
.ropeproject
__pycache__

### OS Generated Files ###
*.out
*.swp
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
Icon?
ehthumbs.db
Thumbs.db

### Vagrant files & directory ###
*.box
.vagrant
```

Now, when you go to run the build process,
you don’t have to worry about it picking up anything that you have added to the `.dockerignore` file.
Once you have created a solid `.dockerignore` file,
you could probably move it from build to build
(unless you create an ignore file based on a specific use case).

Sources:

* [What are .dockerignore files, and why you should use them?](https://www.techrepublic.com/article/what-is-a-dockerignore-file-and-why-you-should-be-using-them/)

#### Step 4: Create and Execute the Docker Image
Now execute the Docker command to build the Docker image to support the application,
tagging it with the name `flask-test`, and place the created image in the current directory (aka `.`):

```bash
# command to create the docker image
sudo docker build --no-cache --tag flask-test:latest .

# check if the image has been created
$ sudo docker image ls flask*
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
flask-test   latest    b1554a2302c0   40 seconds ago   473MB
```

Now execute the new image and expose port 5002 where the HTML file will be served:

```bash
# execute the new image
sudo docker run --name flash-webserver -p 5002:5000 flask-test

# in another terminal window, verify container is running
sudo docker ps -a
```

#### Step 5: Image Cleanup and Rebuild
Docker images consist of multiple layers.
Dangling images are layers that have no relationship to any tagged images.
They no longer serve a purpose and consume disk space.
They can be located by adding the filter flag `-f` with a value of `dangling=true` to the `docker images` command.

```bash
# list all containers with status 'exited'
sudo docker ps -a -f status=exited

# remove all containers with status 'exited'
sudo docker rm $(sudo docker ps -a -f status=exited -q)
```

**Note:** If you build an image without tagging it,
the image will appear on the list of dangling images
because it has no association with a tagged image.
You can avoid this situation by providing a tag when you build,
and you can retroactively tag an image with the docker tag command.

```bash
# purging all unused or dangling images, containers, volumes, and networks
sudo docker system prune

# to additionally remove any stopped containers add the -a flag
sudo docker system prune -a
```

```bash
# to remove the image for rebuilding
sudo docker image rm --force flask-test
```

Sources:

* [How To Remove Docker Images, Containers, and Volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)




[01]:https://flask.palletsprojects.com/en/2.2.x/
[02]:
[03]:
[04]:
[05]:
[06]:
[07]:
[08]:
[09]:
[10]:


