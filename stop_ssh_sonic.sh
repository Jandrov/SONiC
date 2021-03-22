#!/bin/bash

NAME=sonic-ssh

if [[ $(sudo docker container ls -a | grep -o $NAME) ]]; then
    sudo docker rm -f $NAME
    echo "Container $NAME has been removed"
else
    echo "[ERROR] There is no container with name $NAME"
fi
