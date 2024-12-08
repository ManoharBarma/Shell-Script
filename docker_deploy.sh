#!/bin/bash

# Variables
APP_DIR="apps"
REPO_NAME="django-notes-app"
REPO_URL="https://github.com/ManoharBarma/$REPO_NAME.git"
IMAGE_NAME="django-notes-app"
DOCKER_HUB_REPO="manoharbarma/$IMAGE_NAME"

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
docker build -t "$IMAGE_NAME" -f dockerfile . || { echo "[ERROR] Docker image build failed."; exit 1; }

# Step 5: Tag the Docker image
echo "[INFO] Tagging the Docker image for Docker Hub..."
docker tag "$IMAGE_NAME:latest" "$DOCKER_HUB_REPO:latest" || { echo "[ERROR] Failed to tag the Docker image."; exit 1; }

# Step 6: Push the Docker image to Docker Hub
echo "[INFO] Pushing the Docker image to Docker Hub..."
docker push "$DOCKER_HUB_REPO:latest" || { echo "[ERROR] Failed to push the Docker image."; exit 1; }

echo "[INFO] Script execution completed successfully."
