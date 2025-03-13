#!/bin/bash

# Configuration
ACR_NAME="your-acr-name"  # Replace with your Azure Container Registry name
IMAGE_NAME="cotiviti-hackathon-acs-aoai"
IMAGE_TAG="latest"

# Login to Azure
echo "Logging in to Azure..."
az login

# Login to Azure Container Registry
echo "Logging in to Azure Container Registry..."
az acr login --name $ACR_NAME

# Build the Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

# Tag the Docker image for ACR
echo "Tagging Docker image for ACR..."
docker tag $IMAGE_NAME:$IMAGE_TAG $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# Push the Docker image to ACR
echo "Pushing Docker image to ACR..."
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

echo "Done! Image successfully pushed to ACR: $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG"