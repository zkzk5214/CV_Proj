function [y] = forw_maxpool(x)
% Input:       An matrix of size 2M * 2N
% Output:      An matrix of size M * N

a = max(x(1:2:end,1:2:end,:),x(2:2:end,1:2:end,:));
b = max(x(1:2:end,2:2:end,:),x(2:2:end,2:2:end,:));
y = max(a,b);
end
