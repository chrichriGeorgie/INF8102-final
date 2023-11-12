#!/bin/bash

# Prompt for Azure credentials
read -p "Enter your Azure Subscription ID: " subscription_id
read -p "Enter your Azure Client ID: " client_id
read -s -p "Enter your Azure Client Secret: " client_secret
echo ""
read -p "Enter your Azure Tenant ID: " tenant_id

# Export the credentials as environment variables
export ARM_SUBSCRIPTION_ID=$subscription_id
export ARM_CLIENT_ID=$client_id
export ARM_CLIENT_SECRET=$client_secret
export ARM_TENANT_ID=$tenant_id

echo "Azure credentials have been exported as environment variables."