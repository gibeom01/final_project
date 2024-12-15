#!/bin/bash

set -e

echo "Downloading Helm install script..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
if [ $? -ne 0 ]; then
  echo "Error downloading Helm install script"
  exit 1
fi

export AWS_PROFILE=myprofile
aws configure set aws_access_key_id YOUR_AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key YOUR_AWS_SECRET_ACCESS_KEY
aws configure set region ap-northeast-2

echo "Making the script executable..."
chmod +x get_helm.sh

echo "Installing Helm..."
./get_helm.sh

echo "Helm installation completed successfully!"
