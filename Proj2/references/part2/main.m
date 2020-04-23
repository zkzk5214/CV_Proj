% this program is used to find the dominant plane from cloud points 
% author:liming
% 2020-04-23

% inport data 
pointsXYZ = importfile('pointsXYZ.txt');
X = pointsXYZ(:,1);
Y = pointsXYZ(:,2);
Z = pointsXYZ(:,3);
% check data
check_data_flag =1;
    if check_data_flag ==1
        h_fig = figure(4545);
        set(h_fig,'Name','check data');
        plot3(X,Y,Z,'b.')
        grid on
        rotate3d on
        xlabel('x')
        ylabel('y')
        zlabel('z')

    end

    
    
%% algorithm 1
[plane, inliers] = ransacPlane(pointsXYZ, 0.1);

%%
params = struct;
params.inlier_threshold = 0.1;      % in meters
params.min_sample_dist = 0.05;    % in meters
params.confidence = 0.90;
params.error_func = @ransac_error;
[a,b,c,d,inliers,k] = fit_plane(pointsXYZ, params);


%%
%fitted plane
x= -10:0.1:20;
y = -10:0.1:20;
[Xplane,Yplane] = meshgrid(x,y);
Zplane = -(d/c)-(a/c)*Xplane-(b/c)*Yplane;


h_fig = figure(4545);
set(h_fig,'Name','check result');
plot3(X,Y,Z,'b.')
hold on 
plot3(Xplane,Yplane,Zplane);
grid on
rotate3d on
xlabel('x')
ylabel('y')
zlabel('z')






function [error, inliers] = ransac_error(~, distances, threshold)
    inliers = find(distances < threshold);
    outliers = distances >= threshold;
    error = 0* sum(distances(inliers).^2) + 1*sum(distances(outliers).^2);
end


