sudo docker images

#wget https://sonic-jenkins.westus2.cloudapp.azure.com/job/p4/job/buildimage-p4-all/543/artifact/target/docker-sonic-p4.gz
if [ ! -f docker-sonic-p4.gz ]; then
	wget https://sonic-jenkins.westus2.cloudapp.azure.com/job/p4/job/buildimage-p4-all/lastStableBuild/artifact/target/docker-sonic-p4.gz
fi

sudo docker load < docker-sonic-p4.gz
sudo docker pull ubuntu:14.04

#Contruimos las imagenes atendiendo al Dockerfile
sudo docker build .
sudo docker images
