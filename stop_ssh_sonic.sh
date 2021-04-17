#!/bin/bash

SWITCH1=switch1-ssh
SWITCH2=switch2-ssh
NETWORK=my-network

if [[ $(sudo docker container ls -a | grep -o $SWITCH1) ]]; then
    sudo docker rm -f $SWITCH1
    echo "Container $SWITCH1 has been removed"
else
    echo "[ERROR] There is no container with name $SWITCH1"
fi

if [[ $(sudo docker container ls -a | grep -o $SWITCH2) ]]; then
    sudo docker rm -f $SWITCH2
    echo "Container $SWITCH2 has been removed"
else
    echo "[ERROR] There is no container with name $SWITCH2"
fi

sudo docker network rm $NETWORK
echo "Network $NETWORK has been removed"
