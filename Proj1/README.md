# Project 1： 
Modify an existing Siamese Tracker to add functionality that makes it work better.  

## To do lists:

1. run FC baseline
	pytorch
	try to track a occlusion video, probelm?
	how to add kalman filter 
	hwo to crop input image
	correlation map 
zekai liu
mingzhao yu


2. design kalman filter 
	choose one which can be used for our project(py.numpy)
	input? output? 
	how to determine parameters? guess? do we need to train it?
	try to track a occlusion video
chengyu hu
Liming gao

	
deadline: 02282020


3. how to combine kalman filter and siam 

## Object
Video (still slides in the form of a video are fine as well) showing progress made so far on project 1.   
Give an overview of what your are doing for the project.  
Show some of your initial promising results.  
What difficulties are you running in to?  
What ideas do you have to overcome these difficulties?

## Reference

[__基于全连接孪生网络的目标跟踪（siamese-fc)__](https://blog.csdn.net/autocyz/article/details/53216786)  

[__Siamese Networks: Algorithm, Applications And PyTorch Implementation__](https://becominghuman.ai/siamese-networks-algorithm-applications-and-pytorch-implementation-4ffa3304c18)

[__Pytorch-SiamFC-Github__](https://github.com/rafellerc/Pytorch-SiamFC)  

[__Kalman Fitler__](https://github.com/zkzk5214/CV_Proj/blob/master/Proj1/zhou2019.pdf)

[__Kalman_filter_multi_object_tracking__](https://github.com/srianant/kalman_filter_multi_object_tracking)  

[__Kalman-and-Bayesian-Filters-in-Python__](https://github.com/rlabbe/Kalman-and-Bayesian-Filters-in-Python)  

[__Vehicle-Detection-and-Tracking__](https://github.com/kcg2015/Vehicle-Detection-and-Tracking)  

## How to Get Started  
Evaluate the tracker you downloaded, out of the box, on one of the publicly available tracking datasets.  
See what kinds of mistakes it makes.  
Hypothesize how you might improve the tracker to not make those mistakes.  
Implement your improvement.  
Evaluate your improved tracker on the dataset from before, to see if it got better.  
Also, check if there are some sequences it got worse on;this is important because focusing on fixing one problem inadvertently screws up something that used to work before.  
Iterate, Iterate, Iterate. 
