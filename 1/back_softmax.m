function [dzdx] = back_softmax(x,y,dzdy)
% Input:       x An vector of size M * 1 
%              y An vector of size M * 1
%              dzdy An vector of size M * 1
% Output:      dzdx An vector of size M * 1

[m,n] = size(y);
dzdx = zeros(m,1);

for i =1 : m
%     for j = 1 : n
%          if i == j
             dzdx(i) = y(i) * (1-y(i));
%           else
%               dzdx(i) = -y(i)*y(j);
%          end
%  	 end
 end
end
