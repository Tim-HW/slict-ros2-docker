#!/bin/bash

# List of container names to remove
containers=("ros1_bridge" "slict")

# Loop through each container name and remove it
for container in "${containers[@]}"; do
    docker rm -f "$container"
done

docker-compose up