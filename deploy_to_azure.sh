#!/bin/bash

# Set these variables for your environment
APP_NAME=""  # Replace with your Azure App Service name
RESOURCE_GROUP=""  # Replace with your resource group name

# Ensure we're using the right subscription
# az account set --subscription "your-subscription-id"  # Uncomment and replace if needed

# Create a temporary deployment ZIP file
echo "Creating deployment package..."
zip -r deployment.zip . -x "*.git*" -x "__pycache__/*" -x "*.pyc" -x "deploy_to_azure.sh"

# Deploy the application
echo "Deploying to Azure App Service: $APP_NAME..."
az webapp deployment source config-zip --resource-group $RESOURCE_GROUP --name $APP_NAME --src deployment.zip

# Set the startup command to use the specified port (5000)
echo "Setting startup command..."
az webapp config set --resource-group $RESOURCE_GROUP --name $APP_NAME --startup-file "startup.sh"

# Clean up
echo "Cleaning up..."
rm deployment.zip

echo "Deployment complete!"
echo "Your app should be running at: https://$APP_NAME.azurewebsites.net"