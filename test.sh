#!/bin/bash
# First ping from host 2 to switch 2 - this is a patch:
# currently there is a bug with miss on neighbor table (does not trap by default as should)
# When fixed, we can remove it
sudo docker exec -it host2 ping 192.168.2.1 -c10
sleep 2
sudo docker exec -it host1 ping 192.168.2.2 -c10
