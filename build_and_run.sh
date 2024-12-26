#!/bin/bash

# Set the image name and container name
IMAGE_NAME="my-php-laravel-svelte-app"
CONTAINER_NAME="php-laravel-container"

# Build the Docker image
echo "Building Docker image..."
docker build -t $IMAGE_NAME .

# Check if the container is already running and stop it
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
  echo "Stopping running container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
elif [ $(docker ps -aq -f name=$CONTAINER_NAME) ]; then
  # Remove the stopped container if it exists
  echo "Removing stopped container..."
  docker rm $CONTAINER_NAME
fi

# Run the Docker container
echo "Running Docker container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 9090:80 \
  -v $(pwd)/storage:/var/www/html/storage \
  -v $(pwd)/bootstrap/cache:/var/www/html/bootstrap/cache \
  --env-file .env \
  $IMAGE_NAME

echo "Container is running. Access it at http://localhost:80"
