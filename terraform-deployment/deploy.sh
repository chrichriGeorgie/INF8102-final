#!/bin/bash
#setting working directory
cd "$(dirname "$0")"

#AWS credentials configuration
echo Please enter your AWS Access Key ID:
read aws_access_key_id

echo Please enter your AWS Secret Access Key:
read aws_secret_access_key

echo Please enter your AWS Session Token:
read aws_session_token

aws configure set aws_access_key_id $aws_access_key_id
aws configure set aws_secret_access_key $aws_secret_access_key
aws configure set aws_session_token $aws_session_token

echo AWS configuration done.

#Terraform deploying AWS Infrastructure
terraform init
terraform plan
echo Please verifiy the planned deployement
echo "Proceed [y/N]?"
read choice
if [ -z "$choice" ];
then
    choice="y"
fi

if [ $choice = "y" ] || [ $choice = "Y" ];
then
    terraform apply -auto-approve
else
    echo "No instances deployed. Please modify the Terraform configuration and retry. Exiting..."
fi
