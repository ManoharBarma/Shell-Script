#!/bin/bash

    # variables  
    FILE_URL="URL of the file to download"              
    AUTH_TOKEN="Bearer token for authentication"       
    DOWNLOAD_DIR="directory where the file will be saved"          
    FILE_NAME="name of the file to save" 
    
# Function to download file from any URL with Bearer token authentication
download_file() {
    mkdir -p "$DOWNLOAD_DIR"
    curl -H "Authorization: Bearer $AUTH_TOKEN" "$FILE_URL" -o "$DOWNLOAD_DIR/$FILE_NAME"
    echo "File downloaded --> $DOWNLOAD_DIR/$FILE_NAME"
}

download_file
