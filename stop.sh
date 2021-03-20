#!/bin/bash

echo "Borrando los contenedores y bridges con el mismo nombre..."
sudo docker rm -f switch1
sudo docker rm -f switch2
sudo docker rm -f host1
sudo docker rm -f host2
sudo ovs-vsctl del-br switch1_switch2
sudo ovs-vsctl del-br host1_switch1
sudo ovs-vsctl del-br host2_switch2
