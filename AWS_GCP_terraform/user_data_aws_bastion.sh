#!/bin/bash

sudo apt install -y openssh-server
sudo service sshd start

sudo mkdir -p /home/ubuntu/.ssh
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh

echo "${private_key}" | base64 --decode | sudo tee /home/ubuntu/.ssh/gibeom01.pem

sudo chmod 600 /home/ubuntu/.ssh/gibeom01.pem
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/gibeom01.pem

sudo apt install -y zip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version

sudo -u ubuntu aws configure set aws_access_key_id "AKIAQR5EPRGQEV6ZGXOU"
sudo -u ubuntu aws configure set aws_secret_access_key "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"
sudo -u ubuntu aws configure set default.region "ap-northeast-2"
sudo -u ubuntu aws configure set default.output "json"

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.4/2024-09-11/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
aws sts get-caller-identity
kubectl version --client
