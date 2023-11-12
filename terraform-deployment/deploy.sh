#!/bin/bash
#setting working directory
cd "$(dirname "$0")"

#AWS credentials configuration
echo "Do you need to configure AWS credentials [Y/n]?"
read config
if [ -z "$config" ];
then
    config="y"
fi
if [ $config = "y" ] || [ $config = "Y" ];
then
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
fi

#Terraform deploying AWS Infrastructure
terraform init
terraform plan
echo "Please verifiy the planned deployement."
echo "Do you want to proceed with the deployment [Y/n]?"
read deploy
if [ -z "$deploy" ];
then
    deploy="y"
fi

if [ $deploy = "y" ] || [ $deploy = "Y" ];
then
    terraform apply -auto-approve
    echo "Deployment completed. Please wait 30 seconds for instances and services start up."
    sleep 30
    echo "Do you want to clean up the deployment [y/N]?"
    read clean
    if [ -z "$clean" ];
    then
        clean="n"
    fi

    if [ $choice = "y" ] || [ $choice = "Y" ];
    then
        terraform destroy
        echo "Clean up completed."
    fi
else
    echo "No instances deployed. Please modify the Terraform configuration and restart the script."
fi
echo "Thank you!"
