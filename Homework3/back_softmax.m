function [dzdx] = back_softmax(x,y,dzdy)
% Input:       x An vector of size M * 1 
%              y An vector of size M * 1
%              dzdy An vector of size M * 1
% Output:      dzdx An vector of size M * 1

dydx = diag(exp(x)) / sum(exp(x))-y*y';
dzdx = dydx * dzdy;
end
