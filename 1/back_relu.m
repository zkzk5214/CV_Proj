function [dzdx] = back_relu(x,y,dzdy)
% Input:       x An matrix of size M * N
%              y An matrix of size M * N
%              dzdy An matrix of size M * N 
% Output:      dzdx An matrix of size M * N

[m,n]=size(dzdy);   % Array dzdy size M * N
dydx = zeros(m,n);  % Set the fixed size to dydx  
dzdx = zeros(m,n);  % Set the fixed size to dzdx

% The derivative of ReLU(dydx) is 
% f'(x)=1, if x>0 ; 0, otherwise
for X = 1:m
    for Y = 1:n     
        if x(X,Y)>0
            dydx(X,Y) =1;
        else
            dydx(X,Y) =0;
        end
        dzdx(X,Y) = dzdy(X,Y) * dydx(X,Y);  % Chain Rule
    end
end
