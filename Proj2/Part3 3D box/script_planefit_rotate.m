% This program is used to find the dominant plane from cloud points 
% author:liming
% 2020-04-23

clc;clear all;close all;

%%% Find dominant plane
pointsXYZ = load('pointsXYZ.txt');
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
 
%% Rotate 
 
a = bestplane(1);
b = bestplane(2);
c = bestplane(3);
d = bestplane(4);
v = [a,b,c]/norm([a,b,c]); % normal vector of shifted dominant plane(subspace)
syms x11 x12 x13 x21 x22 x23
x1 = [x11,x12,x13]; %  basis of subspace
x2 = [x21,x22,x23]; %
eqn1 = [a,b,c] * x1' == 0;
eqn2 = [a,b,c] * x2' == 0;
eqn3 = x1 * x2' == 0;
eqn4 = norm(x1) == 1;
eqn5 = norm(x2) == 1;
sol = solve([eqn1,eqn2,eqn3,eqn4,eqn5],[x11,x12,x13,x21,x22,x23]);
x1 = double([sol.x11,sol.x12,sol.x13]); % basis 1 of plane
x2 = double([sol.x21,sol.x22,sol.x23]); % basis 2 of plane
R = -[x1;x2;-v];
offset = [d/a/3,d/b/3,d/c/3]; % a(x+d/a/3) + b(y+d/b/3) + c(z+d/c/3) = 0
miu_inliers = [-32.5164,48.8471,0]; %(miu_inliers + offset)*R'
newXYZ = (pointsXYZ+offset)*R' - miu_inliers;
%newXYZ = newXYZ % - miu_inliers;
figure;
plot3(newXYZ(:,1),newXYZ(:,2),newXYZ(:,3),'b.');

% put box in z=0 new coordinates
width_box = 1;
p1 = [width_box/2,width_box/2,0];
p2 = [width_box/2,-width_box/2,0];
p3 = [-width_box/2,-width_box/2,0];
p4 = [-width_box/2,width_box/2,0];
p5 = [width_box/2,width_box/2,width_box];
p6 = [width_box/2,-width_box/2,width_box];
p7 = [-width_box/2,-width_box/2,width_box];
p8 = [-width_box/2,width_box/2,width_box];
C_box_z0 = [p1;p2;p3;p4;p5;p6;p7;p8];% coordinates of box in z=0 coordinates
% rotate 8 corners of box back to XYZ coordinates
C_box_XYZ = (C_box_z0+miu_inliers)*R-offset;% coordinates of box in XYZ coordinates
figure;
P1 = fill3(C_box_XYZ(1:4,1),C_box_XYZ(1:4,2),C_box_XYZ(1:4,3),1);
hold on
P2 = fill3(C_box_XYZ(5:8,1),C_box_XYZ(5:8,2),C_box_XYZ(5:8,3),2);
hold on;
P3 = fill3(C_box_XYZ([1,2,6,5],1),C_box_XYZ([1,2,6,5],2),C_box_XYZ([1,2,6,5],3),3);
hold on;
P4 = fill3(C_box_XYZ([3,4,8,7],1),C_box_XYZ([3,4,8,7],2),C_box_XYZ([3,4,8,7],3),4);
hold on;
plot3(pointsXYZ(:,1),pointsXYZ(:,2),pointsXYZ(:,3),'b.');
 