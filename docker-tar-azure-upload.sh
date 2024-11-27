#!/bin/bash  
build_and_tar() {  
    # variables  
    IMAGE_NAME="docker_image"          
    VERSION="latest"                      
    CONTAINER_NAME="my-container"         
    STORAGE_ACCOUNT_NAME="mystorageaccount"
    STORAGE_ACCOUNT_KEY="my_storage_key"  
    TARBALL="${IMAGE_NAME}_${VERSION}.tar"
    # Docker image build  
    echo "Building Docker image: $IMAGE_NAME:$VERSION..."  
    docker build -t "$IMAGE_NAME:$VERSION" .  

    # Step 2: Save Docker image as tar file  
    echo "Saving Docker image to tar file: $TARBALL..."  
    docker save "$IMAGE_NAME:$VERSION" -o "$TARBALL"  

    # Step 3: Upload tar file to Azure Storage  
    echo "Uploading tar file to Azure Storage container: $CONTAINER_NAME..."  
    az storage blob upload \
        --account-name "$STORAGE_ACCOUNT_NAME" \
        --account-key "$STORAGE_ACCOUNT_KEY" \
        --container-name "$CONTAINER_NAME" \
        --file "$TARBALL" \
        --name "$TARBALL"  

    # Success message  
    echo "Success: Built Docker image, saved tar file, and uploaded to Azure Storage."  
}
# calling function  
build_and_tar
