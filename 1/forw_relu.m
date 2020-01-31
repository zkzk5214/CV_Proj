function [y] = forw_relu(x)
% Input:       x An matrix of size M * N 
% Output:      y An matrix of the same size

% The ReLU is f(x) = max(0,x)
y = max(x,0);
end
