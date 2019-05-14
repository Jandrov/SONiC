sudo docker images
#wget https://sonic-jenkins.westus2.cloudapp.azure.com/job/p4/job/buildimage-p4-all/543/artifact/target/docker-sonic-p4.gz
wget https://localhost/home/javier/entorno_de_trabajo/TFG/SONiC/docker-sonic-p4.gz
sudo docker load < docker-sonic-p4.gz
sudo docker pull ubuntu:latest
sudo docker images
