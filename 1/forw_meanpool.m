function [y] = forw_meanpool(x)
% Input:       An matrix of size 2M * 2N
% Output:      An matrix of size M * N

a = x(1:2:end,1:2:end,:)+x(2:2:end,1:2:end,:);
b = x(1:2:end,2:2:end,:)+x(2:2:end,2:2:end,:);
y = (a+b)/4;
end
