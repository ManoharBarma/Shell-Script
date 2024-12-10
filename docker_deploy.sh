#!/bin/bash

# Variables
REPO_NAME="django-notes-app"
REPO_URL="https://github.com/ManoharBarma/$REPO_NAME.git"
IMAGE_NAME="django-notes-app"
DOCKER_HUB_REPO="manoharbarma/$IMAGE_NAME"

# Step 1: Clone or update the repository
if [ -d "$REPO_NAME" ]; then
  echo "[INFO] Repository '$REPO_NAME' exists. Updating..."
  cd "$REPO_NAME" || { echo "[ERROR] Failed to access the '$REPO_NAME' directory."; exit 1; }
  git pull || { echo "[ERROR] Failed to update the repository."; exit 1; }
else
  echo "[INFO] Cloning the repository from $REPO_URL into current directory..."
  git clone "$REPO_URL" || { echo "[ERROR] Repository cloning failed."; exit 1; }
  cd "$REPO_NAME" || { echo "[ERROR] Failed to access the cloned repository."; exit 1; }
fi

# Step 2: Build the Docker image
echo "[INFO] Building the Docker image '$IMAGE_NAME'..."
docker build -t "$IMAGE_NAME" -f Dockerfile . || { echo "[ERROR] Docker image build failed."; exit 1; }

# Step 3: Tag the Docker image
echo "[INFO] Tagging the Docker image for Docker Hub..."
docker tag "$IMAGE_NAME:latest" "$DOCKER_HUB_REPO:latest" || { echo "[ERROR] Failed to tag the Docker image."; exit 1; }

# Step 4: Push the Docker image to Docker Hub
echo "[INFO] Pushing the Docker image to Docker Hub..."
docker push "$DOCKER_HUB_REPO:latest" || { echo "[ERROR] Failed to push the Docker image."; exit 1; }

echo "[INFO] Script execution completed successfully."
