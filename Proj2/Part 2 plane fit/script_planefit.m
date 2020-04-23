% this program is used to find the dominant plane from cloud points 
% author:liming
% 2020-04-23

clc;clear all;close all;

%%% find dominant plane
pointsXYZ = importfile('pointsXYZ.txt');
X = pointsXYZ(:,1);
Y = pointsXYZ(:,2);
Z = pointsXYZ(:,3);

%%% plot
% check data
check_data_flag =0;
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
%% parameters set for RANSAC
data = pointsXYZ'; % 3*N
number = size(data,2); % total point number
num_sample = 3; % number of points to fit a plane 
confidence = 0.99; % desired good 
p_outlier = 0.7; % probability that a point is outlier
iter = max(10*log(1-confidence)/log(1-power(1-p_outlier,num_sample)),10*number); % number of iteration, for this projet as large as possible 

bestParameter1=0; bestParameter2=0; bestParameter3=0; % best fit parameters
sigma = 0.01;
pretotal=0;     %number of inliers

for i=1:iter
    %choose 3 points randomly
    idx = randsample(number,num_sample);
    sample = data(:,idx);
    
    %fit ax+by+cz+d=0 using normal vector method
    plane_fit = zeros(1,4);
    P1= sample(:, 1);
    P2= sample(:, 2);
    P3= sample(:, 3);
    n = cross(P2 - P1, P3 - P1); % normal vector
    d= - dot(n,P1);
    plane_fit = [n;d]'
    
    % verify the results
    %compare(sample,plane_fit)
    
    %%calculate distance of each points to the plane
    mask=abs(plane_fit*[data; ones(1,size(data,2))])/sqrt(plane_fit(1)^2+plane_fit(2)^2+plane_fit(3)^2);
    
    total=sum(mask<sigma);              % inliers number 
    
    if total>pretotal            %update bset
         pretotal=total;
         bestplane=plane_fit;         
    end  
 end


 %%  plot the points cloud, inliers, and dominant plane
 h_fig = figure(45555);
 set(h_fig,'Name','result data');
 %points cloud
 plot3(X,Y,Z,'b.')
 hold on;
%show inliers
mask=abs(bestplane*[data; ones(1,size(data,2))])/sqrt(plane_fit(1)^2+plane_fit(2)^2+plane_fit(3)^2)<sigma;    
inliers_index = find(mask==1);
fprintf(['Find %d inliers!\n'],length(inliers_index) )
inliers = data(:,inliers_index);
plot3(inliers(1,:),inliers(2,:),inliers(3,:),'r+');
%show dominant plane
 xAxis = min(inliers(1,:)):max(inliers(1,:));
 yAxis = min(inliers(2,:)):max(inliers(2,:));
 [x,y] = meshgrid(xAxis, yAxis);
 z_fit = -bestplane(1) * x/bestplane(3) - bestplane(2)  * y/bestplane(3) - bestplane(4)/bestplane(3) ;
 surf(x, y, z_fit);
 title(['dominant plane: ',num2str(bestplane(1)),'x + ',num2str(bestplane(2)),'y + ',num2str(bestplane(3)),'z + ', num2str(num2str(bestplane(4))),'=0']);
 grid on
 rotate3d on
 xlabel('x')
 ylabel('y')
 zlabel('z')
 legend('points cloud','inliers','dominant plane')
 
 
 function  compare(sample,plane,plane_fit)
 figure(1212)
 xAxis = min(sample(1,:)):0.1:max(sample(1,:));
 yAxis = min(sample(2,:)):0.1:max(sample(2,:));
 [x,y] = meshgrid(xAxis, yAxis);
%z=ax+by+c
 %z = plane(1) * x + plane(2)  * y + plane(4) ;
 
%ax+by+cz+d=0; cz=-ax-by-d 
z_fit = -plane_fit(1) * x/plane_fit(3) - plane_fit(2)  * y/plane_fit(3) - plane_fit(4)/plane_fit(3) ;
%plot3(x, y, z,'b.');
 hold on
 plot3(x, y, z_fit,'m.');
 plot3(sample(1,:), sample(2,:), sample(3,:),'ro');
 
 end