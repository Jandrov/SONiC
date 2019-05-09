#!/bin/bash
#Creacion de contenedores DOCKER
sudo docker run --net=none --privileged --entrypoint /bin/bash --name switch1 -it -d -v $PWD/switch1:/sonic docker-sonic-p4:latest
sudo docker run --net=none --privileged --entrypoint /bin/bash --name switch2 -it -d -v $PWD/switch2:/sonic docker-sonic-p4:latest
sudo docker run --net=none --privileged --entrypoint /bin/bash --name host1 -it -d trusty
sudo docker run --net=none --privileged --entrypoint /bin/bash --name host2 -it -d trusty

#Creamos los puentes que conectan los dispositivos virtuales (hosts y switches):
#Creamos un bridge nuevo
sudo ovs-vsctl add-br switch1_switch2
#Anadimos los puertos correspondientes y conectamos los containers con OVS bridge
sudo ovs-docker add-port switch1_switch2 sw_port0 switch1
sudo ovs-docker add-port switch1_switch2 sw_port0 switch2

#Creamos un bridge nuevo
sudo ovs-vsctl add-br host1_switch1
#Anadimos los puertos correspondientes y conectamos los containers con OVS bridge
sudo ovs-docker add-port host1_switch1 sw_port1 switch1
sudo ovs-docker add-port host1_switch1 eth1 host1

#Creamos un bridge nuevo
sudo ovs-vsctl add-br host2_switch2
#Anadimos los puertos correspondientes y conectamos los containers con OVS bridge
sudo ovs-docker add-port host2_switch2 sw_port1 switch2
sudo ovs-docker add-port host2_switch2 eth1 host2


sudo docker exec -d host1 sysctl net.ipv6.conf.eth0.disable_ipv6=1
sudo docker exec -d host1 sysctl net.ipv6.conf.eth1.disable_ipv6=1
sudo docker exec -d host2 sysctl net.ipv6.conf.eth0.disable_ipv6=1
sudo docker exec -d host2 sysctl net.ipv6.conf.eth1.disable_ipv6=1

#Configuracion de las ip de los hosts
sudo docker exec -d host1 ifconfig eth1 192.168.1.2/24 mtu 1400
sudo docker exec -d host1 ip route replace default via 192.168.1.1
sudo docker exec -d host2 ifconfig eth1 192.168.2.2/24 mtu 1400
sudo docker exec -d host2 ip route replace default via 192.168.2.1


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

echo "Booting switches, please wait ~1 minute for switches to load"
sudo docker exec -d switch1 sh /sonic/scripts/startup.sh
sudo docker exec -d switch2 sh /sonic/scripts/startup.sh
