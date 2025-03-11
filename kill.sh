#!/bin/bash

# List of container names to stop and remove
container_names=("slict" "ros1_bridge")

# Loop through each container name and stop/remove it
for container_name in "${container_names[@]}"; do
  echo "Stopping container $container_name..."
  docker stop "$container_name"

  echo "Removing container $container_name..."
  docker rm "$container_name"
done

echo "All specified containers have been stopped and removed."
