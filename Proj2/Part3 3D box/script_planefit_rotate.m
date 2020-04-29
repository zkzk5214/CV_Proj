% This program is used to find the dominant plane from cloud points 
% author:liming
% 2020-04-23

clc;clear all;close all;


%% =================Part2: Find dominant plane====================
%% step1: load data 
path_pointsXYZ = '.\Part 2 PlaneFit\';
pointsXYZ = load([path_pointsXYZ,'pointsXYZ.txt']);
X = pointsXYZ(:,1);
Y = pointsXYZ(:,2);
Z = pointsXYZ(:,3);

%%% plot
% Whether to check the data(1=Y/0=N)
check_data_flag =0; 
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

%% step2:  parameters set for RANSAC
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


 %% Step3  plot the points cloud, inliers, and dominant plane
 
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
% Show center of dominant plane
dominant_center_x = (min(inliers(1,:))+ max(inliers(1,:)))/2;
dominant_center_y = (min(inliers(2,:))+max(inliers(2,:)))/2;
dominant_center_z =  -bestplane(1) * dominant_center_x/bestplane(3) - bestplane(2)  * dominant_center_y/bestplane(3)...
     - bestplane(4)/bestplane(3);

plot3(dominant_center_x , dominant_center_y ,dominant_center_z,'c.','MarkerSize',25);

 grid on
 rotate3d on
 xlabel('X')
 ylabel('Y')
 zlabel('Z')
 legend('points cloud','inliers','dominant plane')
 
%% =================Part3 Coordinate transformation and 3D box============ 
 
%% step1: define new coordinate 
a = bestplane(1);
b = bestplane(2);
c = bestplane(3);
d = bestplane(4);
v = [a,b,c]'/norm([a,b,c]); % normal vector of shifted dominant plane(subspace)
syms x11 x12 x13 x21 x22 x23
x1 = [x11,x12,x13]; %  basis of subspace
x2 = [x21,x22,x23]; %
eqn1 = [a,b,c] * x1' == 0;
eqn2 = [a,b,c] * x2' == 0;
eqn3 = x1 * x2' == 0;
eqn4 = norm(x1) == 1;
eqn5 = norm(x2) == 1;
sol = solve([eqn1,eqn2,eqn3,eqn4,eqn5],[x11,x12,x13,x21,x22,x23]);
x1 = double([sol.x11,sol.x12,sol.x13]'); % basis 1 of plane
x2 = double([sol.x21,sol.x22,sol.x23]'); % basis 2 of plane
R = -[x1 x2 v];   % coordinate vector of new coordinate
dominant_center = [dominant_center_x  dominant_center_y dominant_center_z];   % coordinate vector of new coordinate
%---------------------old-------------------------------------
%offset = [d/a/3,d/b/3,d/c/3]; % a(x+d/a/3) + b(y+d/b/3) + c(z+d/c/3) = 0
%miu_inliers = [-32.5164,48.8471,0]; %(miu_inliers + offset)*R'
% newXYZ = (pointsXYZ+offset)*R' - miu_inliers;
%^-------------------------------------------------------------------
check_newCoor_flag =1; 
if check_newCoor_flag == 1
    h_fig = figure(300);
    set(h_fig,'Name','new coordinate');
   % plot3(X,Y,Z,'b.')
    hold on
    % dominant plane 
    [x,y] = meshgrid(xAxis, yAxis);
    z_fit = -bestplane(1) * x/bestplane(3) - bestplane(2)  * y/bestplane(3)...
        - bestplane(4)/bestplane(3);   % ax+by+cz+d=0 => z= ...
    surf(x, y, z_fit);
    % new coordinate 
    plot3(dominant_center_x , dominant_center_y ,dominant_center_z,'m.','MarkerSize',25); %o
    quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-v(1),-v(2),-v(3),'b','MaxHeadSize',2,'AutoScaleFactor',1.5,'LineWidth',2) %x
    quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-x1(1),-x1(2),-x1(3),'r','MaxHeadSize',2,'AutoScaleFactor',1.5,'LineWidth',2) %y
    quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-x2(1),-x2(2),-x2(3),'g','MaxHeadSize',2,'AutoScaleFactor',1.5,'LineWidth',2) %z
        title(['New Coordinate']);
    grid on
    rotate3d on
    xlabel('X')
    ylabel('Y')
    zlabel('Z')   
end

%% coodinate transformation, from XYZ to xyz 
newXYZ_inliers = R'*(inliers-  dominant_center');
newXYZ_dominant  = R'*([reshape(x,1,[]); reshape(y,1,[]);reshape(z_fit,1,[])]- dominant_center');

newXYZ_3Dpoints = R'*(pointsXYZ'-  dominant_center');

h_fig = figure(310);
set(h_fig,'Name','Points in new coordinate');
plot3(newXYZ_inliers(1,:),newXYZ_inliers(2,:),newXYZ_inliers(3,:),'g+');
hold on
plot3(newXYZ_3Dpoints(1,:),newXYZ_3Dpoints(2,:),newXYZ_3Dpoints(3,:),'b.');
plot3(newXYZ_dominant(1,:),newXYZ_dominant(2,:),newXYZ_dominant(3,:),'r.');
grid on
rotate3d on
xlabel('x')
ylabel('y')
zlabel('z')
view(90,0)

%% put box in z=0 new coordinates
width_box = 1; 
p1 = [width_box/2,width_box/2,0];
p2 = [width_box/2,-width_box/2,0];
p3 = [-width_box/2,-width_box/2,0];
p4 = [-width_box/2,width_box/2,0];
p5 = [width_box/2,width_box/2,width_box];
p6 = [width_box/2,-width_box/2,width_box];
p7 = [-width_box/2,-width_box/2,width_box];
p8 = [-width_box/2,width_box/2,width_box];
%C_box_z0 = [p1;p2;p3;p4;p5;p6;p7;p8];% coordinates of box in z=0 coordinates
C_box_z0 = [p1;p2;p3;p4];% coordinates of box in z=0 coordinates

h_fig = figure(320);
set(h_fig,'Name','Box in new coordinate');
plot3(C_box_z0(:,1),C_box_z0(:,2),C_box_z0(:,3),'b.','MarkerSize',25);
hold on
plot3(newXYZ_dominant(1,:),newXYZ_dominant(2,:),newXYZ_dominant(3,:),'r.');

surf(reshape(newXYZ_dominant(1,:),size(x)), reshape(newXYZ_dominant(2,:),size(x)), reshape(newXYZ_dominant(3,:),size(x)));
grid on
rotate3d on
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
legend('Box Corner','Dominant Plane','Location','north')
view(-37,25)



%%  rotate 8 corners of box back to XYZ coordinates
% C_box_XYZ = (C_box_z0+miu_inliers)*R-offset;% coordinates of box in XYZ coordinates
C_box_XYZ = R*C_box_z0' + dominant_center';
C_box_XYZ = C_box_XYZ';

h_fig = figure(330);
set(h_fig,'Name','Box in world coordinate');
plot3(C_box_XYZ(:,1),C_box_XYZ(:,2),C_box_XYZ(:,3),'r.','MarkerSize',25);
hold on
% plot3(reshape(x,1,[]), reshape(y,1,[]),reshape(z_fit,1,[]),'r.');
 surf(x, y, z_fit);
% new coordinate
plot3(dominant_center_x , dominant_center_y ,dominant_center_z,'m.','MarkerSize',25); %o
quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-v(1),-v(2),-v(3),'b','MaxHeadSize',2,'AutoScaleFactor',1.5,'LineWidth',2) %x
quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-x1(1),-x1(2),-x1(3),'r','MaxHeadSize',2,'AutoScaleFactor',1.5,'LineWidth',2) %y
quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-x2(1),-x2(2),-x2(3),'g','MaxHeadSize',2,'AutoScaleFactor',1.5,'LineWidth',2) %z
grid on
rotate3d on
axis equal
xlabel('x')
ylabel('y')
zlabel('z')
legend('Box Corner','Dominant Plane','Location','north')
view(-37,20)
%%

figure(340);
plot3(C_box_XYZ(:,1),C_box_XYZ(:,2),C_box_XYZ(:,3),'r.','MarkerSize',25);
hold on 
P1 = fill3(C_box_XYZ(1:4,1),C_box_XYZ(1:4,2),C_box_XYZ(1:4,3),1);
 P2 = fill3(C_box_XYZ(5:8,1),C_box_XYZ(5:8,2),C_box_XYZ(5:8,3),2);
P3 = fill3(C_box_XYZ([1,2,6,5],1),C_box_XYZ([1,2,6,5],2),C_box_XYZ([1,2,6,5],3),3);
P4 = fill3(C_box_XYZ([3,4,8,7],1),C_box_XYZ([3,4,8,7],2),C_box_XYZ([3,4,8,7],3),4);
P5 = fill3(C_box_XYZ([2,3,7,6],1),C_box_XYZ([2,3,7,6],2),C_box_XYZ([2,3,7,6],3),5);
P6 = fill3(C_box_XYZ([1,4,8,5],1),C_box_XYZ([1,4,8,5],2),C_box_XYZ([1,4,8,5],3),6);

 %plot3(pointsXYZ(:,1),pointsXYZ(:,2),pointsXYZ(:,3),'b.');
 surf(x, y, z_fit);
% new coordinate
plot3(dominant_center_x , dominant_center_y ,dominant_center_z,'m.','MarkerSize',25); %o
quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-v(1),-v(2),-v(3),'b','MaxHeadSize',2,'AutoScaleFactor',2,'LineWidth',2) %x
quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-x1(1),-x1(2),-x1(3),'r','MaxHeadSize',2,'AutoScaleFactor',2,'LineWidth',2) %y
quiver3(dominant_center_x , dominant_center_y ,dominant_center_z,-x2(1),-x2(2),-x2(3),'g','MaxHeadSize',2,'AutoScaleFactor',2,'LineWidth',2) %z
grid on
rotate3d on
xlabel('X')
ylabel('Y')
zlabel('Z')
view(-65,15)

title('Box on Dominant plane')

 