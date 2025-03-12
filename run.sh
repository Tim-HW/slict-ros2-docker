#!/bin/bash
xhost +local:docker
# Start Docker containers in detached mode
docker-compose up -d

# Wait for containers to be fully up (adjust sleep time as needed)
sleep 5

# Start SLAM process inside the 'slict' container
docker exec slict /bin/bash -c 'source /ws_slam/devel/setup.bash && roslaunch slict run_blocks2.launch' &

# Start ROS1-ROS2 bridge inside the 'ros1_bridge' container
docker exec ros1_bridge /bin/bash -c '. /opt/ros/foxy/setup.bash && \
                                     . /opt/ros/noetic/setup.bash && \
                                     . /ROS2/install/setup.bash && \
                                     . /ROS1/devel/setup.bash && \
                                     . /bridge_ws/install/setup.bash && \
                                     ros2 run ros1_bridge dynamic_bridge --bridge-all-topics' &
# Start ROS1-ROS2 bridge inside the 'ros1_bridge' container
docker exec slict /bin/bash -c '. /ros_ws/devel/setup.bash && rosrun beginner_tutorials odom.py' &
# Wait for background processes to finish
wait

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