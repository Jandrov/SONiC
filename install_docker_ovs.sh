#!/bin/bash

#sudo apt-get update
#sudo apt-get install -y --no-install-recommends \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    software-properties-common
#curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
#apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
#sudo add-apt-repository \
#       "deb https://apt.dockerproject.org/repo/ \
#       ubuntu-$(lsb_release -cs) \
#       main"
sudo apt-get update
#sudo apt-get -y install docker-engine

sudo apt-get install -y openvswitch-switch
sudo curl -L https://github.com/openvswitch/ovs/raw/master/utilities/ovs-docker -o /usr/bin/ovs-docker
sudo chmod a+x /usr/bin/ovs-docker

