function [y] = forw_relu(x)
% Input:       x An matrix of size M * N 
% Output:      y An matrix of the same size

y = max(x,0);
end
