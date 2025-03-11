import rospy
from nav_msgs.msg import Odometry
import os
import csv

class OdomSubscriber:
    def __init__(self):
        rospy.init_node('odom_subscriber', anonymous=True)
        self.subscriber = rospy.Subscriber('/opt_odom', Odometry, self.odom_callback)
        # Define the file path in the home directory
        self.file_path = os.path.expanduser("/root/results/slict.csv")
        # Open the file in append mode to add new data without overwriting
        self.file = open(self.file_path, mode='a', newline='')
        self.writer = csv.writer(self.file)
        # Write the header if the file is empty
        if os.stat(self.file_path).st_size == 0:
            self.writer.writerow(["timestamp", "x", "y", "z", "ox", "oy", "oz", "ow"])

        # Register a shutdown hook to close the file
        rospy.on_shutdown(self.shutdown_hook)

    def odom_callback(self, msg):
        # Extract the timestamp
        timestamp = msg.header.stamp.secs + msg.header.stamp.nsecs / 1e9

        # Extract the position data
        position = msg.pose.pose.position
        x, y, z = position.x, position.y, position.z

        # Extract the orientation data
        orientation = msg.pose.pose.orientation
        ox, oy, oz, ow = orientation.x, orientation.y, orientation.z, orientation.w
        try:
            # Write the data to the CSV file
            self.writer.writerow([timestamp, x, y, z, ox, oy, oz, ow])
        except:
            pass
        # Print the data to the console
        rospy.loginfo(f"Timestamp: {timestamp}")
        rospy.loginfo(f"Position: x={x}, y={y}, z={z}")
        rospy.loginfo(f"Orientation: x={ox}, y={oy}, z={oz}, w={ow}")
        rospy.loginfo("")

    def shutdown_hook(self):
        rospy.loginfo("Shutting down, closing file.")
        self.file.close()

if __name__ == '__main__':
    try:
        odom_subscriber = OdomSubscriber()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
