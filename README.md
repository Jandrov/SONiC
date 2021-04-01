# SONiC
Repositorio para realizar pruebas de SONiC en redes virtuales.

Tenemos la siguiente topología:
  host1 (Ubuntu 14:04, 192.168.1.2/24) <--> switch1 (SONiC) <--> switch2 (SONiC) <--> host2 (Ubuntu 14:04, 192.168.2.2/24)

1. Ejecutamos el comando: `./install_requirements.sh`
   De esta manera instalamos Docker, open-vsswitch y bridge-utils.

2. Ejecutamos el comando: `./load_image.sh`
   Para cargar y construir la imagen de SONiC-P4

3. Ejecutamos el comando: `./start.sh`
   Para configurar y preparar el entorno. Una vez ejecutado deberíamos tener corriendo 4 contenedores.
   Lo podemos comprobar ejecutando el comando docker ps.

4. Esperamos ~1 minuto para para que se configure todo correctamente...
   Ejecutamos el comando: `./test.sh`
   De esta manera el host1 hará PING al host2 y viceversa.

5. Finalmente ejecutamos el comando: `./stop.sh`
   Con esto borramos los containers y los bridges creados tanto con Docker como con OVS(Open Virtual Switch).

En caso de querer solo un switch virtual con SONiC pero accesible via SSH, entonces hay que ejecutar `source start_ssh_sonic.sh <password>`
Esto comenzará un contenedor con el SONiC de switch1 al que se puede acceder por SSH. Su IP estará en la variable de entorno `SONIC_ADDR` y el usuario será `root`.
De este modo se podrán hacer pruebas conectándonos desde un servicio externo como Postman.
Una vez se quiera parar, solo hay que ejecutar `./stop_ssh_sonic.sh`
