
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

CMD [ "python3", "app.py" ]

