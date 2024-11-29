#!/bin/bash 

    # variables  
    IMAGE_NAME="docker_image"          
    VERSION="latest"                      
    CONTAINER_NAME="my-container"         
    STORAGE_ACCOUNT_NAME="mystorageaccount"
    STORAGE_ACCOUNT_KEY="my_storage_key"  
    TARFILE="${IMAGE_NAME}_${VERSION}.tar"
    
build_and_tar() {  
    # script
    docker build -t "$IMAGE_NAME:$VERSION" .  
    echo "Docker build success"
    docker save "$IMAGE_NAME:$VERSION" -o "$TARFILE"  
    echo "Image saved as $TARFILE"   
    az storage blob upload \
        --account-name "$STORAGE_ACCOUNT_NAME" \
        --account-key "$STORAGE_ACCOUNT_KEY" \
        --container-name "$CONTAINER_NAME" \
        --file "$TARFILE" \
        --name "$TARFILE"  
    echo "$TARFILE upload sucess"
}

build_and_tar
