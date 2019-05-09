wget https://sonic-jenkins.westus2.cloudapp.azure.com/job/p4/job/buildimage-p4-all/543/artifact/target/docker-sonic-p4.gz
wget http://releases.ubuntu.com/16.04/ubuntu-16.04.6-desktop-amd64.iso
sudo docker load < docker-sonic-p4.gz
sudo docker load < ubuntu-16.04.6-desktop-amd64.iso
