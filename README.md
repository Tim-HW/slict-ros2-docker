# Slict-ROS2-Docker

Here is a docker version of SLICT, featuring docker of ROS-bridge to pass messages from ROS1 -> ROS2. This version accepts only Livox custom msg so far but feel free to add more if needed.
This version works with ros a ros bag but you can edit it in the docker-compose file if you want real-time.

## SLICT

https://github.com/brytsknguyen/slict

While feature association to a global map has significant benefits, to keep the computations from growing exponentially, most lidar-based odometry and mapping methods opt to associate features with local maps at one voxel scale. Taking advantage of the fact that surfels (surface elements) at different voxel scales can be organized in a tree-like structure, we propose an octree-based global map of multi-scale surfels that can be updated incrementally. This alleviates the need for recalculating, for example, a k-d tree of the whole map repeatedly. The system can also take input from a single or a number of sensors, reinforcing the robustness in degenerate cases. We also propose a point-to-surfel (PTS) association scheme, continuous-time optimization on PTS and IMU preintegration factors, along with loop closure and bundle adjustment, making a complete framework for Lidar-Inertial continuous-time odometry and mapping.

## Installation
Give permission to script
```bash
chmod +x run.sh
```
```bash
chmod +x kill.sh
```
## Run

```bash
./run.sh
```

## Kill

```bash
./kill.sh
```
##Troublshoot

You may have to change the rosbag path in the docker-compose.yaml
Otherwise it should work
