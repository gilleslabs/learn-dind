#!/bin/sh

######################################################################################################
#                                                                                                    #
#      Setup of $docker variable which will be used for docker VM Shell inline provisioning          #
#                                                                                                    #
######################################################################################################


echo "Build start at    :" > /tmp/build
date >> /tmp/build 

	################     Installing Docker            ###################

sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates -y
sudo apt-key adv --keyserver --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo touch /etc/apt/sources.list.d/docker.list
sudo rm /etc/apt/sources.list.d/docker.list
sudo echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get purge lxc-docker
sudo apt-cache policy docker-engine
sudo apt-get upgrade -y
sudo apt-get install linux-image-extra-$(uname -r) -y
sudo apt-get install docker-engine=1.12.3-0~trusty -y --force-yes
#sudo apt-get install docker-engine -y --force-yes
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker vagrant

################     Installing Docker-Compose            ###################

sudo apt-get -y install python-pip
sudo pip install docker-compose

	################     Updating host and ufw                ###################
	

sudo ufw --force enable

sudo sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|g' /etc/default/ufw
sudo ufw --force reload 
sudo ufw allow 22/tcp
sudo ufw allow 2375/tcp
sudo ufw allow 2376/tcp
sudo ufw allow 2377/tcp

###### Catching IP address of eth1
ip=$(ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

#### Make docker listening on unix socket and eth1
sudo echo DOCKER_OPTS=\"-D --tls=false -H unix:///var/run/docker.sock -H tcp://$ip:2375\" >> /etc/default/docker
sudo service docker restart

echo "Build completed at      :" >> /tmp/build
date >> /tmp/build
cat /tmp/build
echo
