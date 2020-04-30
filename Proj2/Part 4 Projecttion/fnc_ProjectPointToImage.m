%%%%%%%%%%%%  Function fnc_ProjectPointToImage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Purpose:  project 3D point  from world coordinate to Image
%                                 coordinate using perspective principle rather than orthographic
%
% Input Variables:
%        Pworldpts_3D             Point coordinates in world coordinate, 3*N matrix
%        Pose_External            3*4 matrix, [R | t]
%        Camera_Intrinsic        1*4 matrix, [f,cx,cy,k1], fx=fy=f
% Returned Results:
%       Pimagepts           :    projection point at the image 2*N matrix
%
% Processing Flow:
%      Camera Model: https://docs.opencv.org/2.4/modules/calib3d/doc/camera_calibration_and_3d_reconstruction.html
%
% Restrictions/Notes:
%      SimpleRadialCameraModel
%
%  The following functions are called:
%
%  Reference:
%     COLMAP github
%     1.(cameara coor to image coor, camera parameters) https://github.com/colmap/colmap/blob/master/src/base/camera_models.h
%     2. (ProjectPointToImage function) https://github.com/colmap/colmap/blob/dev/src/base/projection.h
%  Author:      LimingGao
%  Date:        04/27/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Pimagepts, Depth] = fnc_ProjectPointToImage(Pworldpts_3D,Pose_External, Camera_Intrinsic )

% Step1: World 3D coordinate to camera 3D coordinate
numpts = size(Pworldpts_3D,2);
Point3D_Homogeneous =  [Pworldpts_3D; ones(1,numpts)];
world_point =  Pose_External * Point3D_Homogeneous;   % 3x4 * 4xN = 3*N
Depth = world_point(3,:); % 1*N,  distance along the principle axis OF THE CAMERA (aka depth) to each point 
world_point_hnormalized = world_point./world_point(3,:);   % 3*N ¡ú 2*N

% Step2: Camera 3D coordinate  to Image coordinate (WorldToImage)
% SimpleRadialCameraModel, refer to https://github.com/colmap/colmap/blob/master/src/base/camera_models.h
f = Camera_Intrinsic(1); % focal lengths expressed in pixel units
cx = Camera_Intrinsic(2);  %(cx, cy) is a principal point that is usually at the image center
cy = Camera_Intrinsic(3);
cxy = [cx;cy];
% distortion
r2 = vecnorm(world_point_hnormalized).^2;
k1 = Camera_Intrinsic(4);
world_point_distortion = world_point_hnormalized + k1*world_point_hnormalized.*r2;  % x'',y''

% Transform to image coordinates
Pimagepts = f*world_point_distortion(1:2,:) + repmat(cxy,1,numpts);

end

