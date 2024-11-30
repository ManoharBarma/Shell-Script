#!/bin/bash

# Variables
FILE_PATH="path_to_your_tarfile.tar"       
UPLOAD_URL="https://upload.endpoint/api" 
AUTH_TOKEN="Bearer your_auth_token"       

# Function to upload files to API endpoint using Bearer token method
upload_file() {
    curl -X POST -H "Authorization: $AUTH_TOKEN" -F "file=@$FILE_PATH" "$UPLOAD_URL" && echo "File uploaded --> $FILE_PATH"
    echo "File uploaded --> $FILE_PATH"
}

# Call the function
upload_file
