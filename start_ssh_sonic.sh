#!/bin/bash

NAME=sonic-ssh

if [ ! $1 ]; then
    echo "[ERROR] Usage is: 'source start_ssh_sonic.sh <root_password>'"
    return
fi

sudo docker run --privileged --entrypoint /bin/bash --name $NAME -it -d -v $PWD/switch1:/sonic docker-sonic-p4:latest
sudo docker exec -d $NAME sh /sonic/scripts/startup.sh

sleep 60
sudo docker ps

sudo docker exec -d $NAME bash -c "echo 'root:$1' | chpasswd"
sudo docker exec -d $NAME sed -i 's/without-password/yes/' /etc/ssh/sshd_config
sudo docker exec -d $NAME service ssh restart

sleep 10

export SONIC_ADDR=$(sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" $NAME)
echo "Container $NAME created and running with $SONIC_ADDR IP address"

