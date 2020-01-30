function [dzdx] = back_relu(x,y,dzdy)
% Input:       x An matrix of size M * N
%              y An matrix of size M * N
%              dzdy An matrix of size M * N 
% Output:      dzdx An matrix of size M * N

[m,n]=size(dzdy);
dydx = zeros(m,n);
dzdx = zeros(m,n);

for X = 1:m
    for Y = 1:n     
        if x(X,Y)>0
            dydx(X,Y) =1;
        else
            dydx(X,Y) =0;
        end
        dzdx(X,Y) = dzdy(X,Y) * dydx(X,Y);
    end
end
