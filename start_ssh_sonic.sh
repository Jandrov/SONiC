#!/bin/bash

NAMES=(switch1-ssh switch2-ssh)
NETWORK=my-network
KERNEL_NAME=$(uname)

# Comprobamos que los parámetros son correctos
# We check that parameters are correct
if [ ! $1 ]; then
    echo "[ERROR] Usage is: 'source start_ssh_sonic.sh <root_password>'"
    return
fi

# Docker en Mac requiere asociar un puerto distinto al estándar de SSH
# Docker on Mac requires mapping a different port to standard SSH port
if [[ "$KERNEL_NAME" == "Darwin" ]]; then
    sudo docker run --privileged --entrypoint /bin/bash --name ${NAMES[0]} -it -d -p 2022:22 -v $PWD/switch1:/sonic docker-sonic-p4:latest
    sudo docker run --privileged --entrypoint /bin/bash --name ${NAMES[1]} -it -d -p 2023:22 -v $PWD/switch1:/sonic docker-sonic-p4:latest
else
    sudo docker run --privileged --entrypoint /bin/bash --name ${NAMES[0]} -it -d -v $PWD/switch1:/sonic docker-sonic-p4:latest
    sudo docker run --privileged --entrypoint /bin/bash --name ${NAMES[1]} -it -d -v $PWD/switch1:/sonic docker-sonic-p4:latest
fi

for name in "${NAMES[@]}"; do
    echo "Starting $name"
    sudo docker exec -d $name sh /sonic/scripts/startup.sh
done

sleep 20
sudo docker ps

for name in "${NAMES[@]}"; do
    echo "Enabling SSH access in $name"
    sudo docker exec -d $name bash -c "echo 'root:$1' | chpasswd"
    sudo docker exec -d $name sed -i 's/without-password/yes/' /etc/ssh/sshd_config
    sudo docker exec -d $name service ssh restart
done

sleep 10

# Docker en Mac expone el contenedor en localhost
# Docker on Mac exposes container in localhost
if [[ "$KERNEL_NAME" == "Darwin" ]]; then
    export SWITCH1_ADDR=localhost
    export SWITCH2_ADDR=localhost
    export SWITCH1_PORT=2022
    export SWITCH2_PORT=2023
else
    export SWITCH1_ADDR=$(sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" ${NAMES[0]})
    export SWITCH2_ADDR=$(sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" ${NAMES[1]})
    export SWITCH1_PORT=22
    export SWITCH2_PORT=22
fi

# Creamos nuestra propia red y conectamos los switches a dicha red
# We create our own network and connect the switches to that network
sudo docker network create $NETWORK
for name in "${NAMES[@]}"; do
    echo "Adding $name to the network $NETWORK"
    sudo docker network connect $NETWORK $name
done

# Obtenemos las direcciones IP asignadas a cada contenedor en nuestra red
# We obtain IP addresses from our network assigned to each container
ADDRESSES=($SWITCH1_ADDR $SWITCH2_ADDR)
PORTS=($SWITCH1_PORT $SWITCH2_PORT)
i=0
sudo docker network inspect -f "{{ .Containers }}" $NETWORK | grep -Eo '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}' | \
    while read ip; do \
        echo "Container ${NAMES[$i]} created and running with ${ADDRESSES[$i]} IP external address, $ip internal address and SSH port ${PORTS[$i]}"; \
        ((i++)); \
    done

echo "Process has finished"
