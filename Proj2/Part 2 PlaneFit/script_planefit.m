% This program is used to find the dominant plane from cloud points 
% author:liming
% 2020-04-23

clc;clear all;close all;

%%% Find dominant plane
pointsXYZ = importfile('pointsXYZ.txt');
X = pointsXYZ(:,1);
Y = pointsXYZ(:,2);
Z = pointsXYZ(:,3);

%%% plot
% Whether to check the data(1=Y/0=N)
check_data_flag =1; 
if check_data_flag == 1
    h_fig = figure(1);
    set(h_fig,'Name','check data');
    plot3(X,Y,Z,'b.')
    grid on
    rotate3d on
    xlabel('x')
    ylabel('y')
    zlabel('z')   
end

%% parameters set for RANSAC
% confidence: Desire probability that we get a good sample
% p_outlier: Probability that a point is an outlier
% num_sample: Number of points to fit a plane 
% iter: Number of samples we want
% sigma: Threshold
% pretotal: Number of inliers
% bestParameter1/2/3: Best fit parameters

data = pointsXYZ'; % 3*N
number = size(data,2); % Total point number

% Looping Parameter
confidence = 0.99;  p_outlier = 0.7;    num_sample = 3; 
bestParameter1=0;   bestParameter2=0;   bestParameter3=0; 
sigma = 0.01;   pretotal=0;    
% Calculate number of loops N, for this projet as large as possible(Unused) 
iter = max(10*log(1-confidence)/log(1-power(1-p_outlier,num_sample))...
    ,10*number);

for i=1:iter
    
    % Choose 3 points randomly
    idx = randsample(number,num_sample);
    sample = data(:,idx);   % 3 points
    
    % Fit ax+by+cz+d=0 using normal vector method
    P1= sample(:, 1);   % point1
    P2= sample(:, 2);   % point2
    P3= sample(:, 3);   % point3
    n = cross(P2 - P1, P3 - P1); % Cross Product: Normal vector(1*3)
    d= - dot(n,P1);
    plane_fit = [n;d]'; % 1*4
    
    % Calculate distance of each points to the plane
    mask=abs(plane_fit*[data; ones(1,size(data,2))])/sqrt...
        (plane_fit(1)^2+plane_fit(2)^2+plane_fit(3)^2);
    
    % Choose inliers  
    total=sum(mask<sigma);   
    
    % Update maximal
    if total>pretotal            
        pretotal=total;
        bestplane=plane_fit;    % [a,b,c,d]         
    end  
 end


 %%  plot the points cloud, inliers, and dominant plane
 
 h_fig = figure(2);
 set(h_fig,'Name','result data');
 
 % Points cloud
 plot3(X,Y,Z,'b.')
 hold on;
 
% Show inliers
mask=abs(bestplane*[data; ones(1,size(data,2))])/sqrt...
    (plane_fit(1)^2+plane_fit(2)^2+plane_fit(3)^2)<sigma;   % Logical    
inliers_index = find(mask==1);
fprintf(('Find %d inliers!\n'),length(inliers_index))
inliers = data(:,inliers_index);
plot3(inliers(1,:),inliers(2,:),inliers(3,:),'r+');

% Show dominant plane
 xAxis = min(inliers(1,:)):max(inliers(1,:));
 yAxis = min(inliers(2,:)):max(inliers(2,:));
 [x,y] = meshgrid(xAxis, yAxis);    
 z_fit = -bestplane(1) * x/bestplane(3) - bestplane(2)  * y/bestplane(3)...
     - bestplane(4)/bestplane(3);   % ax+by+cz+d=0 => z= ...
 surf(x, y, z_fit);
 title(['dominant plane: ',num2str(bestplane(1)),'x + ',...
     num2str(bestplane(2)),'y + ',num2str(bestplane(3)),'z + ', ...
     num2str(num2str(bestplane(4))),'=0']);
 grid on
 rotate3d on
 xlabel('X')
 ylabel('Y')
 zlabel('Z')
 legend('points cloud','inliers','dominant plane')
 