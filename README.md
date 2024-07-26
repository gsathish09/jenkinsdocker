
# INSTALLING KUBECTL ON JENKINS SERVER

[root@ip-172-31-35-224 ~]# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.3/2024-04-19/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 47.4M  100 47.4M    0     0  5613k      0  0:00:08  0:00:08 --:--:-- 7486k


[root@ip-172-31-35-224 ~]# chmod +x ./kubectl


[root@ip-172-31-35-224 ~]# mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH


[root@ip-172-31-35-224 ~]# kubectl version --client

Client Version: v1.29.3-eks-ae9a62a
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3

[root@ip-172-31-35-224 ~]#

# Update the aws cli version and then create kube config ( connect the EKS Cluster )

[root@ip-172-31-35-224 ~]# aws eks update-kubeconfig --region ap-south-1 --name demo-cluster

Updated context arn:aws:eks:ap-south-1:947123667364:cluster/demo-cluster in /root/.kube/config

[root@ip-172-31-35-224 ~]# kubectl get nodes

NAME                                          STATUS   ROLES    AGE   VERSION
ip-192-168-2-92.ap-south-1.compute.internal   Ready    <none>   95m   v1.24.17-eks-ae9a62a

[root@ip-172-31-35-224 ~]#

# CREATE SECRET WHICH WILL PULL THE DOCKER PRIVATE IMAGE

[root@ip-172-31-35-224 .docker]# kubectl create secret generic docker-key --from-file=.dockerconfigjson=/root/.docker/config.json --type=kubernetes.io/dockerconfigjson

secret/docker-key created

[root@ip-172-31-35-224 .docker]#

# TO RUN JENKINS AS SUDO USERS TO RUN KUBECTL COMMAND

go to /etc/sudoers and add as below 

## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
user1   user1=NOPASSWD: ALL
Jenkins ALL=NOPASSWD: ALL


# AFTER TESTING DELETE THE CLUSTER
eksctl delete cluster --name demo-cluster --region ap-south-1