#!/bin/bash
# ------------------------------------------------------------------------------
#
# Maintainer:   jeffskinnerbox@yahoo.com / www.jeffskinnerbox.me
# Version:      1.0.0
#
# DESCRIPTION
#
# SOURCES
#
# ------------------------------------------------------------------------------

#---------------------------- Supporting Functions -----------------------------

# escape characters to change character colors on the terminal
Red='\e[0;31m'                # Red
Green='\e[0;32m'              # Green
NColor='\e[m'                 # Color Reset

# provide highlighted error message if something goes wrong
function error() {
  #echo -e "\\e[91m$1\\e[39m"
  echo -e ${Red}$1${NColor}
  exit 1
}

# check if you have access to the internet since you need to pull files
function check_internet() {
  printf "Checking if you are online..."
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo "Online. Continuing."
  else
    error "Offline. Go connect to the Internet then run the script again."
  fi
}



#------------------------------- Main Execution --------------------------------

# before procedding, make sure you connected to the internet
check_internet

# get portainer's docker container id & name
portainer_pid=`sudo docker ps | grep portainer-ce | awk '{print $1}'`
portainer_name=`sudo docker ps | grep portainer-ce | awk '{print $2}'`

# stop and remove the portainer container & image
sudo docker stop $portainer_pid || error "Failed to stop portainer!"
sudo docker rm $portainer_pid || error "Failed to remove portainer container!"
sudo docker rmi $portainer_name || error "Failed to remove/untag images from the container!"

# install the new version of portainer
sudo docker compose --file ./docker-compose.yml up -d

# wait 5 seconds and then check if portainer is running
sleep 5
if [ -n "$(sudo docker ps -f "name=myapp" -f "status=running" -q )" ]; then
    echo -e "${Green}The portainer container is running!  Installation completed.${NColor}"
else
    error "The portainer container IS NOT RUNNING!  Installation process terminated."
fi

