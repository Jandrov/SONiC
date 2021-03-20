#!/bin/bash
# First ping from host 2 to switch 2 - this is a patch:
# currently there is a bug with miss on neighbor table (does not trap by default as should)
# When fixed, we can remove it
#sudo docker exec -it host2 ping 192.168.2.1 -c10
#sleep 2
#sudo docker exec -it host1 ping 192.168.2.2 -c10

#Ping desde host1 a switch1
sudo docker exec -it host1 ping 192.168.1.1 -c5

#Ping desde switch1 a host1
sudo docker exec -it switch1 ping 192.168.1.2 -c5

#Ping desde host1 a host2
sudo docker exec -it host1 ping 192.168.2.2 -c5

#Ping desde host2 a switch2
sudo docker exec -it host2 ping 192.168.2.1 -c5

#Ping desde switch2 a host2
sudo docker exec -it switch2 ping 192.168.2.2 -c5

#Ping desde host2 a host1
sudo docker exec -it host2 ping 192.168.1.2 -c5