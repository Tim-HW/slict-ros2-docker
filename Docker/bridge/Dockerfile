FROM ros:foxy-ros-base

# Disclaimer : 
# 1.  since livox is using custom msg it is curcial to compile ros bridge from source.
#     Therefore, we cannot take the docker image fox rosbridge as it is using binaries pkg and not source code.
#     That's why we have to install noetic ourself, and compile the packages from source. 
# 2.  
#     Furthermore, The livox_ros_driver2 of this repo is a modified version of the original repo to make it works with the dockers

ENV DEBIAN_FRONTEND=noninteractive
# Update
RUN apt update
# Install ROS1 noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt install curl -y
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt update
RUN apt install ros-noetic-ros-base -y

# Install dependancy for livox ros drive for ROS1
RUN apt install ros-noetic-pcl-ros ros-noetic-tf2-sensor-msgs ros-noetic-image-transport python3-catkin-tools ros-noetic-tf-conversions -y 
RUN apt install libtbb-dev -y 

# Install Livox SDK2
RUN git clone https://github.com/Livox-SDK/Livox-SDK2.git
RUN cd Livox-SDK2 && mkdir build && cd build &&\
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5 &&\
make -j9 &&\
make install

# Get all the packages
COPY livox_ros_driver2  /ROS1/src/livox_ros_driver2   
# Change the packages.xml from this repo to match ROS1
RUN cd /ROS1/src/livox_ros_driver2 && mv package_ROS1.xml package.xml
# Build it with all the necessary arguments
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && cd ROS1 && catkin_make -j1 -DROS_EDITION=ROS1 '

# Install dependancy for livox ros drive for ROS2
RUN apt install ros-foxy-pcl-ros ros-foxy-tf2-sensor-msgs ros-foxy-image-transport ros-foxy-cv-bridge -y 
# Get all the packages
COPY livox_ros_driver2  /ROS2/src/livox_ros_driver2    
# Change the packages.xml from this repo to match ROS1
RUN cd /ROS2/src/livox_ros_driver2 && mv package_ROS2.xml package.xml
# Build it with all the necessary xarguments
RUN /bin/bash -c 'source /opt/ros/foxy/setup.bash && cd ROS2 && colcon build --cmake-args -DROS_EDITION=ROS2 '
# Copy the yaml for remapping the custom msg from livox in order to be detected by ros_bridge
COPY livox_ros_driver2/my_mapping_rules.yaml /ROS2/install/livox_ros_driver2/share/livox_ros_driver2/my_mapping_rules.yaml

# Clone the foxy branch of the ros1_bridge packages
RUN git clone -b foxy https://github.com/ros2/ros1_bridge.git /bridge_ws/src/ros1_bridge
# Build it from source to incorporate custom msg from livox (it takes few minutes)
RUN /bin/bash -c 'source /opt/ros/foxy/setup.bash && source /opt/ros/noetic/setup.bash && source /ROS1/devel/setup.bash && source /ROS2/install/setup.bash && cd bridge_ws && colcon build --cmake-force-configure'


