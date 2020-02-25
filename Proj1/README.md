# Project 1： 
Modify an existing Siamese Tracker to add functionality that makes it work better.  

## To do lists:
### Group 1: (ZL,MY) 
1. Run Siamese-FC using Pytorch
2. Understand the code for Siamese-FC
3. Test an occlusion video using Siamese-FC, find the problem and propose the optimization scheme
4. Where and How to add the Kalman filter 
5. How does the Siamese-FC crop the input image

### Group 2: (CH LG)
1. Choose an kalman filter 
2. Understand the code for this Kalman filter 
3. Input and output parameters 
4. How to combine Kalman filter and Siam-FC? do we need to train?
5. Use this filter to track the occlusion video separately
	
deadline: 02/28/2020

## Assignment
1. Video (still slides in the form of a video are fine as well) showing progress made so far on project 1.   
2. Give an overview of what your are doing for the project.  
3. Show some of your initial promising results.  
4. What difficulties are you running in to?  
5. What ideas do you have to overcome these difficulties?

## Reference

### Important
[__Pytorch-SiamFC-Github__](https://github.com/rafellerc/Pytorch-SiamFC)  

[__Kalman Fitler__](https://github.com/zkzk5214/CV_Proj/blob/master/Proj1/zhou2019.pdf)

### Others
[__基于全连接孪生网络的目标跟踪（siamese-fc)__](https://blog.csdn.net/autocyz/article/details/53216786)  

[__Siamese Networks: Algorithm, Applications And PyTorch Implementation__](https://becominghuman.ai/siamese-networks-algorithm-applications-and-pytorch-implementation-4ffa3304c18)

[__Kalman_filter_multi_object_tracking__](https://github.com/srianant/kalman_filter_multi_object_tracking)  

[__Kalman-and-Bayesian-Filters-in-Python__](https://github.com/rlabbe/Kalman-and-Bayesian-Filters-in-Python)  

[__Vehicle-Detection-and-Tracking__](https://github.com/kcg2015/Vehicle-Detection-and-Tracking)  

## How to Get Started  
1. Evaluate the tracker, out of the box, on one of the publicly available tracking datasets.  
2. See what kinds of mistakes it makes.  
3. Hypothesize how you might improve the tracker to not make those mistakes.  
4. Implement your improvement.  
5. Evaluate your improved tracker on the dataset from before, to see if it got better.  
6. Check if there are some sequences it got worse on(this is important because focusing on fixing one problem inadvertently screws up something that used to work before)
7. Iterate, Iterate, Iterate. 
