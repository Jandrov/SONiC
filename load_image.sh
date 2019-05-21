wget https://sonic-jenkins.westus2.cloudapp.azure.com/job/p4/job/buildimage-p4-all/543/artifact/target/docker-sonic-p4.gz
sudo docker load < docker-sonic-p4.gz
sudo docker --pull ubuntu

#Contruimos las imagenes atendiendo al Dockerfile
sudo docker build -t ubuntu:latest
sudo docker build -t docker-sonic-p4:latest

sudo docker images
