#!/bin/bash
docker-compose up -d

docker exec slict /bin/bash -c 'source /ws_slam/devel/setup.bash && roslaunch slict run_slam.launch'



#docker exec ros1_bridge /bin/bash -c '. /opt/ros/foxy/setup.bash && . /opt/ros/noetic/setup.bash  &&. /ROS2/install/setup.bash && . /ROS1/devel/setup.bash && . /bridge_ws/install/setup.bash && ros2 run ros1_bridge dynamic_bridge --bridge-all-topics'

