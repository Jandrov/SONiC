#!/bin/bash

NAME=sonic-ssh

# Check correct parameters
if [ ! $1 ]; then
    echo "[ERROR] Usage is: 'source start_ssh_sonic.sh <root_password>'"
    return
fi

KERNEL_NAME=$(uname)

# Docker on Mac requires mapping a different port to standard SSH port
if [[ "$KERNEL_NAME" == "Darwin" ]]; then
    sudo docker run --privileged --entrypoint /bin/bash --name $NAME -it -d -p 2022:22 -v $PWD/switch1:/sonic docker-sonic-p4:latest
else
    sudo docker run --privileged --entrypoint /bin/bash --name $NAME -it -d -v $PWD/switch1:/sonic docker-sonic-p4:latest
fi

sudo docker exec -d $NAME sh /sonic/scripts/startup.sh

sleep 60
sudo docker ps

sudo docker exec -d $NAME bash -c "echo 'root:$1' | chpasswd"
sudo docker exec -d $NAME sed -i 's/without-password/yes/' /etc/ssh/sshd_config
sudo docker exec -d $NAME service ssh restart

sleep 10

# Docker on Mac exposes container in localhost
if [[ "$KERNEL_NAME" == "Darwin" ]]; then
    export SONIC_ADDR=localhost
    export SONIC_PORT=2022
else
    export SONIC_ADDR=$(sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" $NAME)
    export SONIC_PORT=22
fi

echo "Container $NAME created and running with $SONIC_ADDR IP address and SSH port $SONIC_PORT"

