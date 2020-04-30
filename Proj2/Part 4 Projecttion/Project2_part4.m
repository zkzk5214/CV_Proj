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

%%Step3: load scene points coordinates 
Pworldpts_3Dbox = C_box_XYZ';

%%Step4: WorldPointToImagePoint
num_images = length(images);
Pimagepts_3Dbox = zeros(2,length(Pworldpts_3Dbox),length(images));
for image_i=1:num_images
    Pose_External = [images(image_i).R images(image_i).t];
    %Camera_Intrinsic = [cameras(images(image_i).camera_id).params]';
    Camera_Intrinsic = [cameras(1).params]';
    
   Pimagepts_3Dbox(:,:,image_i) = fnc_ProjectPointToImage(Pworldpts_3Dbox,Pose_External, Camera_Intrinsic);
    
end

%% Step5: show pictures and box corners projection
images_path = '.\Part 1 COLMAP\images\';
for image_i=1:num_images
    I = rgb2gray(imread([images_path,'image',num2str(image_i),'.jpg']));

    h_fig = figure(1000+image_i);
    set(h_fig,'Name',['Image',num2str(image_i),' and projection' ]);
    colormap(gray);
    clf;
    % subplot(2,1,1);
    imagesc(I);
    hold on
    plot(Pimagepts_3Dbox(1,1:4,image_i),Pimagepts_3Dbox(2,1:4,image_i),'r.','MarkerSize',25);
    plot(Pimagepts_3Dbox(1,5:8,image_i),Pimagepts_3Dbox(2,5:8,image_i),'b.','MarkerSize',25);
    hold off
    drawnow
    legend('Lower 4 corners (z=0)','Upper 4 corners')
end


%% Step6: show pictures and box corners projection
images_path = '.\Part 1 COLMAP\images\';
for image_i=1:num_images
    I = rgb2gray(imread([images_path,'image',num2str(image_i),'.jpg']));

    h_fig = figure(1000+image_i);
    set(h_fig,'Name',['Image',num2str(image_i),' and projection' ]);
    colormap(gray);
    clf;
    % subplot(2,1,1);
    imagesc(I);
    hold on
    plot(Pimagepts_3Dbox(1,1:4,image_i),Pimagepts_3Dbox(2,1:4,image_i),'r.','MarkerSize',25);
    plot(Pimagepts_3Dbox(1,5:8,image_i),Pimagepts_3Dbox(2,5:8,image_i),'b.','MarkerSize',25);
    hold off
    drawnow
    legend('Lower 4 corners (z=0)','Upper 4 corners')
end


