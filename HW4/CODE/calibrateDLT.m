function [K,Pose] = calibrateDLT(Pworldpts,Pimagepts)
% I1 = rgb2gray(imread('rubik1.jpg'));
% I2 = rgb2gray(imread('rubik2.jpg'));
% load rubikPoints.mat
% Pimagepts = Pimagepts1;
% numpts = size(Pworldpts,2);

% u(i)=Pworldpts(1,i); 
% v(i)=Pworldpts(2,i); 
% w(i)=Pworldpts(3,i);    % Pw
% x(i)=Pimagepts(1,i); 
% y(i)=Pimagepts(2,i);    % p

% A
n=1;
for i=1:size(Pimagepts,2) % 37
    A(n,:)=[Pworldpts(1,i), Pworldpts(2,i), Pworldpts(3,i),...
        1, 0, 0, 0, 0, -Pworldpts(1,i)*Pimagepts(1,i),...
        -Pworldpts(2,i)*Pimagepts(1,i), -Pworldpts(3,i)*Pimagepts(1,i),...
        -Pimagepts(1,i)];
    A(n+1,:)=[0, 0, 0, 0, Pworldpts(1,i), Pworldpts(2,i), Pworldpts(3,i),...
        1, -Pworldpts(1,i)*Pimagepts(2,i), -Pworldpts(2,i)*Pimagepts(2,i),...
        -Pworldpts(3,i)*Pimagepts(2,i), -Pimagepts(2,i)];
    n=n+2;
end

% Compute matrix Pmat using SVD 
% A=USV'
[~,~,V] = svd(A);
% X
X=V(:,12);
Pmat = reshape(X,4,3)';

% Verify that Pmat * [u;v;w;1] for one of the world points in the 
% rubik?s cube model has third coordinate > 0
for i = 1:size(Pworldpts,2)
    s= Pmat.*[Pworldpts(1,i);Pworldpts(2,i);Pworldpts(3,i)];
end
% If the third coordinate is < 0, negate all the values of Pmat.
if s(3,:)<0
    Pmat=-Pmat;
end

Pa = Pmat(:,1:3);
Pb = Pmat(:,4);

% RQ decomposition 
[K,R] = rq(Pa);

% Solve t and [R|t]
t= K\Pb;
Pose = [R(1,1),R(1,2),R(1,3),t(1,1);
    R(2,1),R(2,2),R(2,3),t(2,1);
    R(3,1),R(3,2),R(3,3),t(3,1)];

end
