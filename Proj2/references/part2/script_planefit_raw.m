clc;clear all;close all;

%%% find dominant plane
pointsXYZ = importfile('pointsXYZ.txt');
X = pointsXYZ(:,1);
Y = pointsXYZ(:,2);
Z = pointsXYZ(:,3);



%%% plot
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
%% parameters set for RANSAC
data = pointsXYZ'; % 3*N
number = size(data,2); % total point number
num_sample = 3; % number of points to fit a plane 
confidence = 0.99; % desired good 
p_outlier = 0.7; % probability that a point is outlier
iter = max(10*log(1-confidence)/log(1-power(1-p_outlier,num_sample)),10*number);

bestParameter1=0; bestParameter2=0; bestParameter3=0; % best fit parameters
sigma = 0.01;
pretotal=0;     %number of inliers

for i=1:iter
    %choose 3 points randomly
     idx = randsample(number,num_sample);
     sample = data(:,idx); 

     %%%fit  z=ax+by+c
     plane = zeros(1,3);
     x = sample(:, 1);
     P1= sample(:, 1);
     y = sample(:, 2);
     P2= sample(:, 2);

     P3= sample(:, 3);
      % 下面这个四行是错的
     a = ((z(1)-z(2))*(y(1)-y(3)) - (z(1)-z(3))*(y(1)-y(2)))/((x(1)-x(2))*(y(1)-y(3)) - (x(1)-x(3))*(y(1)-y(2)));
     b = ((z(1) - z(3)) - a * (x(1) - x(3)))/(y(1)-y(3));
     c = z(1) - a * x(1) - b * y(1);
     plane = [a b -1 c]
     
     
     % fit ax+by+cz+d=0 using normal vector method 
     
      n = cross(P2 - P1, P3 - P1); % normal vector
      d= - dot(n,P1);
      plane_fit = [n;d]'
      
      % verify the results 
      %compare(sample,plane,plane_fit)

     %mask=abs(plane*[data; ones(1,size(data,2))])/sqrt(a^2+b^2+1);
     %%calculate distance of each points to the plane 
     mask=abs(plane_fit*[data; ones(1,size(data,2))])/sqrt(plane_fit(1)^2+plane_fit(2)^2+plane_fit(3)^2);
     
     total=sum(mask<sigma);              %计算数据距离平面小于一定阈值的数据的个数

     if total>pretotal            %找到符合拟合平面数据最多的拟合平面
         pretotal=total;
         bestplane=plane_fit;          %找到最好的拟合平面
    end  
 end
 %显示符合最佳拟合的数据
mask=abs(bestplane*[data; ones(1,size(data,2))])<sigma;    
hold on;
k = 1;
for i=1:length(mask)
    if mask(i)
        inliers(1,k) = data(1,i);
        inliers(2,k) = data(2,i);
        plot3(data(1,i),data(2,i),data(3,i),'r+');
        k = k+1;
    end
end

 %%% 绘制最佳匹配平面
 bestParameter1 = bestplane(1);
 bestParameter2 = bestplane(2);
 bestParameter3 = bestplane(4);
 xAxis = min(inliers(1,:)):max(inliers(1,:));
 yAxis = min(inliers(2,:)):max(inliers(2,:));
 [x,y] = meshgrid(xAxis, yAxis);
 % z = bestParameter1 * x + bestParameter2 * y + bestParameter3;
 z_fit = -bestplane(1) * x/bestplane(3) - bestplane(2)  * y/bestplane(3) - bestplane(4)/bestplane(3) ;
 surf(x, y, z_fit);
 %title(['bestPlane:  z =  ',num2str(bestParameter1),'x + ',num2str(bestParameter2),'y + ',num2str(bestParameter3)]);
 
 
 
 function  compare(sample,plane,plane_fit)
 figure(1212)
 xAxis = min(sample(1,:)):0.1:max(sample(1,:));
 yAxis = min(sample(2,:)):0.1:max(sample(2,:));
 [x,y] = meshgrid(xAxis, yAxis);
%z=ax+by+c
 z = plane(1) * x + plane(2)  * y + plane(4) ;
 
%ax+by+cz+d=0; cz=-ax-by-d 
z_fit = -plane_fit(1) * x/plane_fit(3) - plane_fit(2)  * y/plane_fit(3) - plane_fit(4)/plane_fit(3) ;
plot3(x, y, z,'b.');
 hold on
 plot3(x, y, z_fit,'m.');
 plot3(sample(1,:), sample(2,:), sample(3,:),'ro');
 
 end