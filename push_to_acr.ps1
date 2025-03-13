param(
    [string]$AcrName = $env:ACR_NAME,
    [string]$ImageName = $env:IMAGE_NAME,
    [string]$ImageTag = $env:IMAGE_TAG
)

# Try to load from .env file if parameters are not provided
if (-not $AcrName -or -not $ImageName -or -not $ImageTag) {
    if (Test-Path -Path ".\.env") {
        Write-Host "Loading environment variables from .env file..." -ForegroundColor Yellow
        Get-Content -Path ".\.env" | ForEach-Object {
            if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()
                
                # Remove quotes if present
                if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") {
                    $value = $matches[1]
                }
                
                if ($key -eq "ACR_NAME" -and -not $AcrName) { $AcrName = $value }
                if ($key -eq "IMAGE_NAME" -and -not $ImageName) { $ImageName = $value }
                if ($key -eq "IMAGE_TAG" -and -not $ImageTag) { $ImageTag = $value }
            }
        }
    }
}


# Display configuration
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  ACR Name:  $AcrName" -ForegroundColor Cyan
Write-Host "  Image Name: $ImageName" -ForegroundColor Cyan
Write-Host "  Image Tag:  $ImageTag" -ForegroundColor Cyan
Write-Host ""

# Rest of your script continues...
Write-Host "Logging in to Azure..." -ForegroundColor Green
az login

# Get your Azure subscription ID
Write-Host "Getting subscription information..." -ForegroundColor Green
$SUBSCRIPTION_ID = (az account show --query id -o tsv)
Write-Host "Using subscription: $SUBSCRIPTION_ID" -ForegroundColor Green

# Continue with the rest of your script, using the variables
Write-Host "Ensuring proper ACR access..." -ForegroundColor Green
az acr update -n $AcrName --admin-enabled true

# Get the ACR credentials
Write-Host "Getting ACR credentials..." -ForegroundColor Green
$ACR_USERNAME = (az acr credential show -n $AcrName --query username -o tsv)
$ACR_PASSWORD = (az acr credential show -n $AcrName --query "passwords[0].value" -o tsv)

# Login to Docker with ACR credentials
Write-Host "Logging in to Docker with ACR credentials..." -ForegroundColor Green
echo $ACR_PASSWORD | docker login "$AcrName.azurecr.io" -u $ACR_USERNAME --password-stdin

# Build the Docker image
Write-Host "Building Docker image..." -ForegroundColor Green
docker build -t "${ImageName}:${ImageTag}" .

# Tag the Docker image for ACR
Write-Host "Tagging Docker image for ACR..." -ForegroundColor Green
docker tag "${ImageName}:${ImageTag}" "${AcrName}.azurecr.io/${ImageName}:${ImageTag}"

# Push the Docker image to ACR
Write-Host "Pushing Docker image to ACR..." -ForegroundColor Green
docker push "${AcrName}.azurecr.io/${ImageName}:${ImageTag}"

Write-Host "Done! Image successfully pushed to ACR: ${AcrName}.azurecr.io/${ImageName}:${ImageTag}" -ForegroundColor Green