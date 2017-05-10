#!/bin/bash
ip=$(ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

sudo ufw allow 12375/tcp
sudo ufw allow 22375/tcp
sudo ufw allow 32375/tcp
sudo ufw allow 42375/tcp
sudo ufw allow 12377/tcp

# init Swarm master
docker swarm init --advertise-addr $ip
sleep 10
# get join token
SWARM_TOKEN=$(docker swarm join-token -q worker)
SWARM_MGR_TOKEN=$(docker swarm join-token -q manager)

# get Swarm master IP (Docker for VM IP)
SWARM_MASTER=$(docker info | grep -w 'Node Address' | awk '{print $3}')

## Adding a manager
docker run -d --privileged --name manager2 --hostname=manager2 -p 12377:2378 -p 42375:2375 docker:1.12.1-dind
sleep 10
docker --host=${SWARM_MASTER}:42375 swarm join --token ${SWARM_MGR_TOKEN}  ${SWARM_MASTER}:2377

# run NUM_WORKERS workers with SWARM_TOKEN
NUM_WORKERS=3
for i in $(seq "${NUM_WORKERS}"); do
  docker run -d --privileged --name worker-${i} --hostname=worker-${i} -p ${i}2375:2375 docker:1.12.1-dind
  sleep 10
  docker --host=${SWARM_MASTER}:${i}2375 swarm join --token ${SWARM_TOKEN} ${SWARM_MASTER}:2377
done

docker node ls
docker run -it -d --name swarm_visualizer \
  -p 8000:8080 -e HOST=localhost \
  -v /var/run/docker.sock:/var/run/docker.sock \
  manomarks/visualizer
