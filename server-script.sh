#! /bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user #add the ec2-user into docker group so that ec2-user can run docker command
sudo docker run -itd -p 8080:80 nginx
