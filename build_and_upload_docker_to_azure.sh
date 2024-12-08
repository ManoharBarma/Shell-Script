#!/bin/bash

# Variables 
REPO_URL="https://github.com/ManoharBarma/django-notes-app.git"       
IMAGE_NAME="django-notes-app"                                     
STORAGE_ACCOUNT_NAME="mystorageaccount"                            
STORAGE_ACCOUNT_KEY="my_storage_key"                               
CONTAINER_NAME="my-container"                                      
VERSION="latest"                                                   
TARFILE="${IMAGE_NAME}_${VERSION}.tar"                             
APP_DIR="apps"                                                     
REPO_NAME=$(basename "$REPO_URL" .git)                             

build_and_upload_to_azure() {
  # Step 1: Ensure the apps directory exists
  echo "[INFO] Ensuring the '$APP_DIR' directory exists..."
  [ -d "$APP_DIR" ] || mkdir -p "$APP_DIR" || { echo "[ERROR] Failed to create the '$APP_DIR' directory."; exit 1; }

  # Step 2: Navigate to the apps directory
  echo "[INFO] Navigating to the '$APP_DIR' directory..."
  cd "$APP_DIR" || { echo "[ERROR] Unable to access the '$APP_DIR' directory."; exit 1; }

  # Step 3: Clone or update the repository
  if [ -d "$REPO_NAME" ]; then
    echo "[INFO] Repository '$REPO_NAME' exists. Updating..."
    cd "$REPO_NAME" || { echo "[ERROR] Failed to access the '$REPO_NAME' directory."; exit 1; }
    git pull || { echo "[ERROR] Failed to update the repository."; exit 1; }
  else
    echo "[INFO] Cloning the repository from $REPO_URL..."
    git clone "$REPO_URL" || { echo "[ERROR] Repository cloning failed."; exit 1; }
    cd "$REPO_NAME" || { echo "[ERROR] Failed to access the cloned repository."; exit 1; }
  fi

  # Step 4: Build the Docker image
  echo "[INFO] Building the Docker image '$IMAGE_NAME'..."
  docker build -t "$IMAGE_NAME:$VERSION" -f dockerfile . || { echo "[ERROR] Docker image build failed."; exit 1; }

  # Step 5: Save Docker image as a TAR file
  echo "[INFO] Saving Docker image as '$TARFILE'..."
  docker save "$IMAGE_NAME:$VERSION" -o "$TARFILE" || { echo "[ERROR] Failed to save Docker image."; exit 1; }

  # Step 6: Upload the image to Azure Blob Storage
  echo "[INFO] Uploading '$TARFILE' to Azure Storage..."
  az storage blob upload \
      --account-name "$STORAGE_ACCOUNT_NAME" \
      --account-key "$STORAGE_ACCOUNT_KEY" \
      --container-name "$CONTAINER_NAME" \
      --file "$TARFILE" \
      --name "$TARFILE" || { echo "[ERROR] Failed to upload the image to Azure."; exit 1; }

  echo "[INFO] $TARFILE upload successful and all tasks completed!"
}

# Run the function
build_and_upload_to_azure
