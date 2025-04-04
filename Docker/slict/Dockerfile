FROM ros:noetic-ros-base

# Install build dependencies
RUN apt-get update && apt-get install -y \
      libsqlite3-dev \
      build-essential\
      git \
      cmake \
      libyaml-cpp-dev \
      software-properties-common \
      pkg-config \ 
      wget \
      curl \
      libgflags-dev \
      libgoogle-glog-dev \
      libpdal-dev \
      libsuitesparse-dev \
      wget 

# Install newer CMAKE
RUN wget https://github.com/Kitware/CMake/releases/download/v4.0.0-rc1/cmake-4.0.0-rc1.tar.gz && tar -xzf cmake-4.0.0-rc1.tar.gz
RUN cd cmake-4.0.0-rc1 &&\
    ./bootstrap &&\
    make -j9 &&\
    make install
# Install newer Eigen
RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz && tar -xzf eigen-3.4.0.tar.gz
RUN cd eigen-3.4.0 &&\
    mkdir build && cd build &&\
    cmake .. &&\
    make -j9 &&\
    make install
# Install ceres 2.10
RUN git clone https://ceres-solver.googlesource.com/ceres-solver &&\
    cd ceres-solver && git fetch --all --tags &&\
    git checkout tags/2.1.0 &&\
    mkdir build && cd build &&\
    cmake .. && make -j5 &&\
    make install
# Install Sophus
RUN git clone https://github.com/strasdat/Sophus &&\
    cd Sophus &&\
    mkdir build && cd build &&\
    cmake .. &&\
    make -j1 &&\
    make install
# Install Livox SDK
RUN git clone https://github.com/Livox-SDK/Livox-SDK.git
RUN cd Livox-SDK/build &&\
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5 &&\
make -j9 &&\
make install
# Install Livox SDK2
RUN git clone https://github.com/Livox-SDK/Livox-SDK2.git
RUN cd Livox-SDK2 && mkdir build && cd build &&\
cmake .. -DCMAKE_POLICY_VERSION_MINIMUM=3.5 &&\
make -j9 &&\
make install

# Remove interactions
ENV DEBIAN_FRONTEND=noninteractive
# Install dependancy
RUN apt install ros-noetic-pcl-ros ros-noetic-tf2-sensor-msgs ros-noetic-image-transport python3-catkin-tools ros-noetic-cv-bridge ros-noetic-tf-conversions -y 
RUN apt install libtbb-dev -y 
# Get all the packages
RUN git clone https://github.com/brytsknguyen/livox_ros_driver /ws_slam/src/livox_ros_driver
RUN git clone https://github.com/Livox-SDK/livox_ros_driver2.git /ws_slam/src/livox_ros_driver2   
RUN git clone https://github.com/brytsknguyen/ufomap /ws_slam/src/ufomap
# Build and install ufomap
RUN cd /ws_slam/src/ufomap && git checkout devel_surfel && cd ufomap && mkdir build && cd build && cmake .. && make -j9 && make install
# Then remove it to not interfer with catkin_make
RUN cd /ws_slam/src/ufomap && rm -rf ufomap
# Change the packages.xml from this repo to match ROS1
RUN cd /ws_slam/src/livox_ros_driver2 && mv package_ROS1.xml package.xml
# Build it with all the necessary arguments
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && cd ws_slam && catkin_make -DROS_EDITION=ROS1 -DCMAKE_POLICY_VERSION_MINIMUM=3.5'
# Clone the SLAM repo
RUN git clone https://github.com/brytsknguyen/slict.git /ws_slam/src/slict
# Copy the launch file for our dataset

# Build it along with all the other packages
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && cd ws_slam && catkin_make -j1'

RUN apt update --fix-missing && apt install ros-noetic-rviz -y

COPY beginner_tutorials ros_ws/src/beginner_tutorials
# Build it along with all the other packages
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash && cd ros_ws && catkin_make -DCMAKE_POLICY_VERSION_MINIMUM=3.5'