Using RANSAC for estimating geometric transforms in computer vision

Random sample consensus is an iterative method for estimating a mathematical model from a data set that contains outliers. The RANSAC algorithm works by identifying the outliers in a data set and estimating the desired model using data that does not contain outliers.

RANSAC is accomplished with the following steps :

1.	Randomly selecting a subset of the data set
2.	Fitting a model to the selected subset
3.	Determining the number of outliers
4.	Repeating steps 1-3 for a prescribed number of iterations

Research paper :

Face detection and tracking in video sequences using the modified census transformation
http://dl.acm.org/citation.cfm?id=1709264

Approach :

Detection is performed by creating a cascade detector object – Viola Johnes
1.	Create a cascade detector object for initial face detection : CascadeObjectDetector('FrontalFaceCART');
2.	save location of face as a polygon 

The tracking is performed by means of continuous detection.
1.	Create and Initialize Tracker
2.	Find points on detected objects using minimum eigen features
3.	Loop through video, get the next frame, Use vision.pointTracker to track feature points
4.	Keep only the valid points and discard the rest, Save the new state of the point tracker
5.	If new visible points>2, filter outliers using RANSAC
6.	Find bounding box by applying the transformation to the bounding box from previous frame to current frame
7.	Insert the bounding box around the object being tracked
8.	Display tracked points