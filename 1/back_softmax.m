function [dzdx] = back_softmax(x,y,dzdy)
% Input:       x An vector of size M * 1 
%              y An vector of size M * 1
%              dzdy An vector of size M * 1
% Output:      dzdx An vector of size M * 1

der = -y'*y + diag(y,0);
dzdx = der * dzdy;
end
