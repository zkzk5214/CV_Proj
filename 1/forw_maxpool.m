function [y] = forw_maxpool(x)
% Input:       An matrix of size 2N * 2M
% Output:      An matrix of the size N * M

a = max(x(1:2:end,1:2:end,:),x(2:2:end,1:2:end,:));
b = max(x(1:2:end,2:2:end,:),x(2:2:end,2:2:end,:));
y = max(a,b);
end
