#!/bin/bash

# List of container names to remove
containers=("slictdocker")
DOCKER_IMG=slictdocker

# Loop through each container name and remove it
for container in "${containers[@]}"; do
    docker rm -f "$container"
done

docker run \
        -it \
        --rm \
        --net=host \
        -v ./data:/root/dataset/ \
        -e USER=root \
        $DOCKER_IMG \
        bash

