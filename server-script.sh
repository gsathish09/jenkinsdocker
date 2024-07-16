#! /bin/bash

sudo yum install git -y
# sudo yum insatll java-1.8.0-openjdk-devel -y
# sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker


if [ -d "jenkinsdocker" ]
then
   echo "repo is cloned and exists"
   cd jenkinsdocker
   git pull origin feature/cicd-docker
else
   #git clone https://github.com/preethid/addressbook.git
   git clone https://github.com/gsathish09/jenkinsdocker.git
   cd jenkinsdocker
   git checkout feature/cicd-docker
fi

sudo docker build -t $1 .