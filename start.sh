#!/bin/bash

# Creacion de contenedores Docker
# Creation of Docker containers
sudo docker run --net=none --privileged --entrypoint /bin/bash --name switch1 -it -d -v $PWD/switch1:/sonic docker-sonic-p4:latest
sudo docker run --net=none --privileged --entrypoint /bin/bash --name switch2 -it -d -v $PWD/switch2:/sonic docker-sonic-p4:latest
sudo docker run --net=none --privileged --entrypoint /bin/bash --name host1 -it -d ubuntu:14.04 
sudo docker run --net=none --privileged --entrypoint /bin/bash --name host2 -it -d ubuntu:14.04

sudo docker ps

# Creamos los puentes que conectan los dispositivos virtuales (hosts y switches):
# We create the bridges that connect the virtual devices (hosts and switches):

# Creamos un bridge nuevo
# We create a new bridge
sudo ovs-vsctl add-br switch1_switch2
# Anadimos los puertos correspondientes y conectamos los containers con OVS bridge
# We add the corresponding ports and connect the containers with OVS bridge
sudo ovs-docker add-port switch1_switch2 sw_port0 switch1
sudo ovs-docker add-port switch1_switch2 sw_port0 switch2

# Creamos un bridge nuevo
# We create a new bridge
sudo ovs-vsctl add-br host1_switch1
# Anadimos los puertos correspondientes y conectamos los containers con OVS bridge
# We add the corresponding ports and connect the containers with OVS bridge
sudo ovs-docker add-port host1_switch1 sw_port1 switch1
sudo ovs-docker add-port host1_switch1 eth1 host1

# Creamos un bridge nuevo
# We create a new bridge
sudo ovs-vsctl add-br host2_switch2
# Anadimos los puertos correspondientes y conectamos los containers con OVS bridge
# We add the corresponding ports and connect the containers with OVS bridge
sudo ovs-docker add-port host2_switch2 sw_port1 switch2
sudo ovs-docker add-port host2_switch2 eth1 host2

# Configuramos la red en los hosts
# We configure the network in the hosts
sudo docker exec -d host1 sysctl net.ipv6.conf.eth0.disable_ipv6=1
sudo docker exec -d host1 sysctl net.ipv6.conf.eth1.disable_ipv6=1
sudo docker exec -d host2 sysctl net.ipv6.conf.eth0.disable_ipv6=1
sudo docker exec -d host2 sysctl net.ipv6.conf.eth1.disable_ipv6=1

sudo docker exec -d host1 ifconfig eth1 192.168.1.2/24 mtu 1400
sudo docker exec -d host1 ip route replace default via 192.168.1.1
sudo docker exec -d host2 ifconfig eth1 192.168.2.2/24 mtu 1400
sudo docker exec -d host2 ip route replace default via 192.168.2.1

# Configuramos la red en los switches
# We configure the network in the switches
sudo docker exec -d switch1 ip netns add sw_net
sudo docker exec -d switch1 ip link set dev sw_port0 netns sw_net
sudo docker exec -d switch1 ip netns exec sw_net sysctl net.ipv6.conf.sw_port0.disable_ipv6=1
sudo docker exec -d switch1 ip netns exec sw_net ip link set sw_port0 up
sudo docker exec -d switch1 ip link set dev sw_port1 netns sw_net
sudo docker exec -d switch1 ip netns exec sw_net sysctl net.ipv6.conf.sw_port1.disable_ipv6=1
sudo docker exec -d switch1 ip netns exec sw_net ip link set sw_port1 up

sudo docker exec -d switch2 ip netns add sw_net
sudo docker exec -d switch2 ip link set dev sw_port0 netns sw_net
sudo docker exec -d switch2 ip netns exec sw_net sysctl net.ipv6.conf.sw_port0.disable_ipv6=1
sudo docker exec -d switch2 ip netns exec sw_net ip link set sw_port0 up
sudo docker exec -d switch2 ip link set dev sw_port1 netns sw_net
sudo docker exec -d switch2 ip netns exec sw_net sysctl net.ipv6.conf.sw_port1.disable_ipv6=1
sudo docker exec -d switch2 ip netns exec sw_net ip link set sw_port1 up

echo "Iniciando los switches, por favor espere ~1 minuto para que se carguen correctamente"
sudo docker exec -d switch1 sh /sonic/scripts/startup.sh
sudo docker exec -d switch2 sh /sonic/scripts/startup.sh
sleep 60

sudo docker ps
