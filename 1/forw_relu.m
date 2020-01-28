function [y] = forw_relu(x)
% Input:       An array of size N * M * D
% Output:      An array of the same size
y = max(x,0);
end
