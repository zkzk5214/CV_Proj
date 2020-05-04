function [dzdx,dzdw,dzdb] = back_fc(x,w,b,y,dzdy)
% Input:       x An matrix of size M * N
%              w An matrix of size M * N 
%              b a scalar bias value
%              y a scalar value (output from forward pass) 
%              dzdy a scalar value dx/dy
% Output:      dzdx an matrix of size M * N 
%              dzdw an matrix of size M * N  
%              dzdb a value 

% dydw = x
dzdw = dzdy .* x;
% dydx = w
dzdx = dzdy .* w;
% dydb = 1
dzdb = dzdy;
end
