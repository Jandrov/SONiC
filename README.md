# SONiC
Repositorio para realizar pruebas de SONiC en redes virtuales.

## Requisitos para ambos entornos
Estos scripts deben ejecutarse al menos una vez antes de poder cargar alguno de los dos entornos siguientes, pues necesitaremos algunos programas y las imágenes de Docker.

1. Ejecutamos el comando: `./install_requirements.sh`
   De esta manera instalamos Docker, open-vsswitch y bridge-utils.

2. Ejecutamos el comando: `./load_image.sh`
   Para cargar y construir las imágenes de SONiC-P4 y Ubuntu 14.04.


### Entorno habitual de SONIC P4 Software Switch descrito [aquí](https://github.com/Azure/SONiC/wiki/SONiC-P4-Software-Switch)
Tendremos la siguiente topología:
  host1 (Ubuntu 14:04, 192.168.1.2/24) <--> switch1 (SONiC) <--> switch2 (SONiC) <--> host2 (Ubuntu 14:04, 192.168.2.2/24)

1. Ejecutamos el comando: `./start.sh`
   Para configurar y preparar el entorno. Una vez ejecutado deberíamos tener corriendo 4 contenedores.
   Lo podemos comprobar ejecutando el comando `docker ps`.

2. Esperamos ~1 minuto para para que se configure todo correctamente...
   Ejecutamos el comando: `./test.sh`
   De esta manera el host1 hará PING al host2 y viceversa.

3. Finalmente ejecutamos el comando: `./stop.sh`
   Con esto borramos los containers y los bridges creados tanto con Docker como con OVS (Open Virtual Switch).


### Entorno de pruebas de mi TFG de Ingeniería Informática
Tendremos la siguiente topología:
  [accesible por SSH] --> switch1 (SONiC) <-[eth1]---my-network---[eth1]-> switch2 (SONiC) <-- [accesible por SSH]

En caso de querer los dos switches virtuales con SONiC pero accesibles via SSH, tenemos que ejecutar `source start_ssh_sonic.sh <password>`.
Esto comenzará dos contenedores con el SONiC del directorio switch1 al que se puede acceder por SSH. Sus IPs estarán en las variables de entorno `SWITCH1_ADDR` y `SWITCH2_ADDR`, sus puertos SSH en `SWITCH1_PORT` y `SWITCH2_PORT`, y el usuario será `root` (con la contraseña pasada como argumento del script). Además, para controlar la comunicación entre ellos, vamos a crear una red de Docker `my-network` y añadiremos los contenedores a ella. Ambos tendrán entonces la interfaz `eth1` con distintas IPs v4.
De este modo se podrán hacer pruebas conectándonos desde un servicio externo como Postman (con RESTCONF) a alguno de ellos.
Una vez se quiera parar todo, solo hay que ejecutar `./stop_ssh_sonic.sh`, que elimina los contenedores y la red creada.



# SONiC (English version)
Repository to make tests of SONiC in virtual networks.

## Requirements for both environments
These scripts must be executed at least once before being able to load any of the two environments, because we will need some programs and Docker images.

1. We run the command: `./install_requirements.sh`
   In this way we install Docker, open-vsswitch y bridge-utils.

2. We run the command: `./load_image.sh`
   To load and build SONiC-P4 and Ubuntu 14.04 images.


### Entorno habitual de SONIC P4 Software Switch descrito [aquí](https://github.com/Azure/SONiC/wiki/SONiC-P4-Software-Switch)
We will have the next topology:
  host1 (Ubuntu 14:04, 192.168.1.2/24) <--> switch1 (SONiC) <--> switch2 (SONiC) <--> host2 (Ubuntu 14:04, 192.168.2.2/24)

1. We run the command: `./start.sh`
   To configure and prepare the environment. Once executed, we should have 4 containers running.
   We can check it by running command `docker ps`.

2. We wait ~1 minute to let everything be properly configured...
   We run the command: `./test.sh`
   In this way, host1 will PING host2 and vice-versa.

3. Finally, we run the command: `./stop.sh`
   With this, we remove the containers and bridges that were created both with Docker and OVC (Open Virtual Switch).


### Test environment for my Computer Science bachelor's thesis
We will have the next topology:
  [accessible by SSH] --> switch1 (SONiC) <-[eth1]---my-network---[eth1]-> switch2 (SONiC) <-- [accessible by SSH]

If we want the two virtual switches with SONiC but accessibles via SSH, we have to run `source start_ssh_sonic.sh <password>`.
This will start two containers with SONiC from switch1 directory, that will be accessible by SSH. Their IPs will be stored in the environment variables `SWITCH1_ADDR` and `SWITCH2_ADDR`, their SSH ports in `SWITCH1_PORT` and `SWITCH2_PORT`, and the user will be `root` (with the password entered as script's first parameter). Besides, to control the communication between them, we will create a Docker network `my-network` and we will add the containers to it. Both then will have interface `eth1` with different IPs v4.
In this way we will be able to make some tests by connecting to any of them from an external service like Postman (with RESTCONF).
Once we want to stop everything, we just need to run  `./stop_ssh_sonic.sh`, that will remove the containers and the network.
