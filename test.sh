#!/bin/bash

# First ping from host 2 to switch 2 - this is a patch:
# currently there is a bug with miss on neighbor table (does not trap by default as should)
# When fixed, we can remove it
sudo docker exec -it host2 ping 192.168.2.1 -c10
sleep 2
sudo docker exec -it host1 ping 192.168.2.2 -c10

# Ping host1 -> switch1
sudo docker exec -it host1 ping 192.168.1.1 -c5

# Ping switch1 -> host1
sudo docker exec -it switch1 ping 192.168.1.2 -c5

# Ping host1 -> host2
sudo docker exec -it host1 ping 192.168.2.2 -c5

# Ping host2 -> switch2
sudo docker exec -it host2 ping 192.168.2.1 -c5

# Ping switch2 -> host2
sudo docker exec -it switch2 ping 192.168.2.2 -c5

# Ping host2 -> host1
sudo docker exec -it host2 ping 192.168.1.2 -c5