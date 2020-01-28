function [y] = forw_relu(x)
% Input:       An matrix of size M * N 
% Output:      An matrix of the same size

y = max(x,0);
end
