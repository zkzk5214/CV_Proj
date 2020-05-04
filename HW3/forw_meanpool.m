function [y] = forw_meanpool(x)
% Input:       x An matrix of size 2M * 2N
% Output:      y An matrix of size M * N

% Find the mean between NW NE 
a = x(1:2:end,1:2:end,:)+x(2:2:end,1:2:end,:);
% Find the mean between SW SE
b = x(1:2:end,2:2:end,:)+x(2:2:end,2:2:end,:);
% Find the mean between NW NE SW SE
y = (a+b)/4;
end
