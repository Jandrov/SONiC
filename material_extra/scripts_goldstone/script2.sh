#!/bin/bash

cd ~/environment/goldstone-mgmt/
$K exec ds/gs-mgmt-cli -- gscli -c "platform; show" | grep sys
cd ..
sudo k3s kubectl create -f usonic/k8s
export SONIC_MGMT_ADDR=$($K get svc sonic-mgmt -o=jsonpath='{.spec.clusterIP}{"\n"}')
while [ true ]; do   sleep 10;   (curl http://$SONIC_MGMT_ADDR/restconf/data/sonic-port:sonic-port | grep Ethernet1) && exit 0 || true; done
