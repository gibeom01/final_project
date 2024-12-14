#!/bin/bash

sudo apt update -y
sudo apt install -y openssh-server
sudo service sshd start

sudo mkdir -p /home/ubuntu/.ssh
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh

echo "${private_key}" | base64 --decode | sudo tee /home/ubuntu/.ssh/gibeom01.json > /dev/null

sudo chmod 600 /home/ubuntu/.ssh/gibeom01.json
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/gibeom01.json

sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update -y
sudo apt-get install -y google-cloud-cli
sudo apt-get install -y google-cloud-cli-gke-gcloud-auth-plugin

sudo -u ubuntu gcloud auth activate-service-account --key-file=/home/ubuntu/.ssh/gibeom01.json
sudo -u ubuntu gcloud config set project deep-thought-440807-g3

curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client

echo 'export PATH=$PATH:/usr/local/bin' | sudo tee -a /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc

gcloud auth list
gcloud config list
