function [predicted, distances] = triangulateDLT(K1,Pose1,Pimagepts1,K2,Pose2,Pimagepts2)
% load rubikPoints.mat
% K1 =[0.0526   -0.000145087993044565    0.0213;
%          0    0.0525    0.0152;
%          0         0    2.16590134781008e-05];
% K2 =[0.0562   -2.510436198032377e-04    0.0199;
%          0    0.0565    0.0182;
%          0         0    2.346235727084569e-05;];
% Pose1 =[0.5544   -0.0485   -0.8308    0.8414;
%    -0.3816    0.8724   -0.3056    6.1402;
%     0.7396    0.4865    0.4651   28.5197];
% Pose2 =[0.7119    0.0024   -0.7022    0.9633;
%    -0.3696    0.8515   -0.3718    4.7616;
%     0.5971    0.5243    0.6071   28.2371];     

Pmat1 = K1*Pose1; Pmat2 = K2*Pose2;

P1_1x = Pmat1(1,:); P1_2x = Pmat1(2,:); P1_3x = Pmat1(3,:);
P2_1x = Pmat2(1,:); P2_2x = Pmat2(2,:); P2_3x = Pmat2(3,:);

% 3D coordinates
Norm = zeros(12,4);

for i = 1 : size(Pimagepts1,2)  % 37
    x1 = Pimagepts1(1,i);   % P1
    y1 = Pimagepts1(2,i);
    
    x2 = Pimagepts2(1,i);   % P2
    y2 = Pimagepts2(2,i);
    
    A = [y1*P1_3x-P1_2x ; P1_1x-x1*P1_3x ; y2*P2_3x-P2_2x ; P2_1x-x2*P2_3x];
    
    [V,D] = eig(A'*A);
    [~,ind] = sort(diag(D));
    Vs = V(:,ind);
    x = Vs(:,1);
    Norm(i,:) = x./x(4);
end
% [U;V;W;1]
predicted = Norm(:,1:3)';

%% compute distance

distances = zeros(1,size(Pimagepts1,2));

for i = 1 : size(Pimagepts1,2)
    
    R1 = Pose1(:,1:3);
    R2 = Pose2(:,1:3);
    T1 = Pose1(:,4);
    T2 = Pose2(:,4);
    
    c1 = R1'*T1;
    c2 = R2'*T2;
    K1=K1/K1(3,3);
    K2=K2/K2(3,3);
    u1 = R1'*(K2\[Pimagepts1(:,i);1])/norm(R1'*(K2\[Pimagepts1(:,i);1]));
    u2 = R2'*(K2\[Pimagepts2(:,i);1])/norm(R1'*(K2\[Pimagepts1(:,i);1]));
    u3 = cross(u1,u2)/norm(cross(u1,u2));
    
    syms a b d
    Left = c2-c1;
    Equation = (a*u1 + d*u3 -b*u2 ==Left);
    Var = [a b d];
    [a,b,d] = solve(Equation, Var);
    a = double(a); b = double(b); d = double(d);
    
    p1 = c1+a*u1;
    p2 = c2+b*u2;
    P = 0.5*(p1+p2);
    
    P1 = c1;
    P2 = c1+u1;
    distances(i) = norm(cross(P2-P1,P-P1))/norm(P2-P1);
    
end

