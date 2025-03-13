#!/bin/bash

# Navigate to the deployment directory
cd "$DEPLOYMENT_TARGET" || exit 1

# Check if the tar.gz file exists
if [ -f "output.tar.gz" ]; then
    # Extract the contents
    tar -xzf output.tar.gz
    # Remove the archive after extraction
    rm output.tar.gz
    echo "Deployment package extracted successfully"
fi

# Create a startup command file for Linux App Service
if [ ! -f "startup.sh" ]; then
    echo "Creating startup.sh file"
    cat > startup.sh << EOF
#!/bin/bash
gunicorn --bind=0.0.0.0:5000 app:app
EOF
    chmod +x startup.sh
fi

echo "Deployment complete"
exit 0