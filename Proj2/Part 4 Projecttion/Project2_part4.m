%%%%%%%%%%%%  Function   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Purpose: Project 2 EE545
% Matlab work Path: ~\GitHub\CV_Proj\Proj2
%  Author:      LimingGao
%  Date:        04/27/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; 
close all;
addpath('.\Part 4 Projecttion\');
addpath('.\Part3 3D box\');
%% Step1:  Run Part 1-3 to generate dominiant plane and 3D box
script_planefit_rotate

%% Step2: load model parameters
path = '.\Part 1 COLMAP\';
[images,cameras] = fnc_readModel(path);
if ~strcmp(cameras(1).model, 'SIMPLE_RADIAL')
    error('This camera is not SIMPLE_RADIAL model.');
end
% refer to github https://github.com/colmap/colmap/tree/dev/scripts/matlab
% [cameras, images,points3D] = read_model(path);
% plot_model(cameras, images, points3D)


%% Step3: load scene points coordinates 

Pworldpts_3Dbox = C_box_XYZ';
% points_8 = Get_3D_rect(x, y, rect)    # points_8含有8个3D点，维度是4*8的array
% img_points_8 = np.matmul(Ps[cam], points_8)    # 3*4的P矩阵和点进行相乘
% img_points_8 = img_points_8/img_points_8[2,:]	# homogeneous进行归一化，之后可以在image上绘制

%% Step4: WorldToImage
num_images = length(images);
for image_i=1:1 %num_images
    Pose_External = [images(image_i).R images(image_i).t];
    Camera_Intrinsic = [cameras(images(image_i).camera_id).params]';
    
   % [Pimagepts] = fnc_ProjectPointToImage(Pworldpts_3D,Pose_External, Camera_Intrinsic)
    
end

%% Step5: 
images_path = '.\Part 1 COLMAP\images\';
I1 = rgb2gray(imread([images_path,'image1.jpg']));
I2 = rgb2gray(imread([images_path,'image2.jpg']));
% I3 = rgb2gray(imread('image3.jpg'));
% I4 = rgb2gray(imread('image4.jpg'));
% I5 = rgb2gray(imread('image5.jpg'));
% I6 = rgb2gray(imread('image6.jpg'));

figure(100); 
colormap(gray); 
clf; 
subplot(2,1,1);
imagesc(I1);
hold on
subplot(2,1,2);
imagesc(I2);
hold off
drawnow