'''
This script tracking a object using opencv and kalman filter.

To do list:
1. https://stackoverflow.com/questions/42941634/kalman-filter-in-a-video


referecne:
https://www.hdm-stuttgart.de/~maucher/Python/ComputerVision/html/Tracking.html#kalman-filter


Author: Liming Gao
Date: 03/01/2020

'''

import cv2
import numpy as np
import string
import os,sys #for file management make directory
import shutil #for file management, copy file
import matplotlib.pyplot as plt
import time
from pykalman import KalmanFilter


#def main(args):

plt.rcParams.update({'figure.max_open_warning': 0})
#plt.rc('figure', max_open_warning = 0)
print("start..")
file="singleball.mov"
print(file)
capture = cv2.VideoCapture(file)
# capture.set(3,160) # width
# capture.set(4,120) # height
print "\t Width: ",capture.get(cv2.CAP_PROP_FRAME_WIDTH)
print "\t Height: ",capture.get(cv2.CAP_PROP_FRAME_HEIGHT)
print "\t FourCC: ",capture.get(cv2.CAP_PROP_FOURCC)
print "\t Framerate: ",capture.get(cv2.CAP_PROP_FPS)
numframes=capture.get(7)
print "\t Number of Frames: ",numframes



#Next the parameters of the background subtractor class are defined and an object of this class is generated:

count=0
history = 11
nGauss = 3
bgThresh = 0.6
noise = 20
varThreshold = 4.16
#bgs = cv2.BackgroundSubtractorMOG(history,nGauss,bgThresh,noise)
bgs = cv2.bgsegm.createBackgroundSubtractorMOG(history,nGauss,bgThresh,noise)
#bgs = cv2.createBackgroundSubtractorMOG2(history = history,varThreshold = varThreshold,detectShadows=True)
# createBackgroundSubtractorMOG2(int history=500, double varThreshold=16, bool detectShadows=true )


# A matplotlib figure is initialized. Within the following loop for each frame the location of the detected object will be plotted into this figure:

# the plot 
fig = plt.figure()
measure_data = np.array([[0,0]]) #measured value
filterOutput_data = np.array([[0,0]]) #filtered data
ax = fig.add_subplot(111)
plt.hold(True)
Lm, = ax.plot(measure_data[0],'r*',label='measured')
Lf, = ax.plot(filterOutput_data[0],'b.',label='kalman output')
plt.axis([0,520,360,0])
plt.title("Constant Velocity Kalman Filter")
plt.ion() #Turn the interactive mode on.
plt.show()

# system matrix, constant velocity motion
Transition_Matrix=[[1,0,1,0],[0,1,0,1],[0,0,1,0],[0,0,0,1]]
Observation_Matrix=[[1,0,0,0],[0,1,0,0]]
transistionCov=1.0e-4*np.eye(4)  # W matrix, can set it to be 0
observationCov=1.0e-1*np.eye(2)  # the Q matrix
kf=KalmanFilter(transition_matrices=Transition_Matrix,
			observation_matrices =Observation_Matrix,
			transition_covariance=transistionCov,
			observation_covariance=observationCov)



measuredTrack=np.zeros((int(numframes),2))-1
init_flag = 0 # start the kalman filter when contour detected
while count<numframes:

	img2 = capture.read()[1]
	cv2.imshow("Video",img2)
	foremat=bgs.apply(img2)
	cv2.waitKey(150)
	foremat=bgs.apply(img2)
	#cv2.imshow("imgary",foremat)
	ret,thresh = cv2.threshold(foremat,127,255,0)
	_,contours, hierarchy = cv2.findContours(thresh,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
	# update measure data if contours are detected
	if len(contours) > 0:
		m= np.mean(contours[0],axis=0)
		measuredTrack[count,:]=m[0]

	# mask if there is no update, the coordinate is [-1,-1]
	Current_measure = measuredTrack[count,:]
	current_measurement=np.ma.masked_less(Current_measure,0) # miss detection 
	cmx, cmy = current_measurement[0], current_measurement[1]
	# initilize the state and covariance
	if init_flag==0 and current_measurement.mask.any() == False:
		filtered_state_covariances=1.0e-3*np.eye(4)  #
		xinit=Current_measure[0]
		yinit=Current_measure[1]
		vxinit=0
		vyinit=0
		# vxinit=Measured[1,0]-Measured[0,0]
		# vyinit=Measured[1,1]-Measured[0,1]
		filtered_state_means=[xinit,yinit,vxinit,vyinit]
		init_flag = 1
	'''
	Perform a one-step update to estimate the state at time t+1 give an observation at time t+1 and the previous estimate for time t given observations from times [0...t].
	This method is useful if one wants to track an object with streaming observations.
	input: X(k-1|k-1),P(k-1|K-1),Z(k)
	output; X(k|k),P(k|k)

	refercne:https://blog.csdn.net/qq_23981335/article/details/82968422
	https://pykalman.github.io/#kalmanfilter

	'''
	if init_flag == 1:
		next_filtered_state_mean, next_filtered_state_covariance = kf.filter_update( filtered_state_means,filtered_state_covariances,current_measurement)

		cpx,cpy= next_filtered_state_mean[0], next_filtered_state_mean[1]

		print(next_filtered_state_mean.data[:])
		filterOutput_data = np.append(filterOutput_data,[next_filtered_state_mean.data[0:2]],axis = 0)
		Lf.set_xdata(filterOutput_data[:,0])
		Lf.set_ydata(filterOutput_data[:,1])

		# update state
		filtered_state_means, filtered_state_covariances=next_filtered_state_mean, next_filtered_state_covariance
	# update the plot 
	try:
		if current_measurement.mask == False:
			measure_data = np.append(measure_data,[current_measurement.data],axis = 0)
			Lm.set_xdata(measure_data[:,0])
			Lm.set_ydata(measure_data[:,1])
	except:
		if current_measurement.mask[0] == False and current_measurement.mask[1] == False:
			measure_data = np.append(measure_data,[current_measurement.data],axis = 0)
			Lm.set_xdata(measure_data[:,0])
			Lm.set_ydata(measure_data[:,1])
		#print([current_measurement.data])

	plt.pause(0.001)


	cv2.imshow('Foreground',foremat)
	cv2.waitKey(80)

	count += 1

plt.savefig('Kalman_tracking.png')
capture.release()
print measuredTrack
np.save("ballTrajectory", measuredTrack)
np.save("ballTrajectory_withKalman", filterOutput_data)




	#when everything done, release the capture




# if __name__ == '__main__':
# 	main(sys.argv)