sudo docker images

if [ ! -f docker-sonic-p4.gz ]; then
	wget https://sonic-jenkins.westus2.cloudapp.azure.com/job/p4/job/buildimage-p4-all/lastStableBuild/artifact/target/docker-sonic-p4.gz
fi

sudo docker load < docker-sonic-p4.gz
sudo docker pull ubuntu:14.04

# Construimos las imagenes atendiendo al Dockerfile
# We build the images according to the Dockerfile
sudo docker build .
sudo docker images
