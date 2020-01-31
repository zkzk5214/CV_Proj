function [y] = forw_maxpool(x)
% Input:       x An matrix of size 2M * 2N
% Output:      y An matrix of size M * N

% Find the bigger number between NW NE 
a = max(x(1:2:end,1:2:end,:),x(2:2:end,1:2:end,:));
% Find the bigger number between SW SE
b = max(x(1:2:end,2:2:end,:),x(2:2:end,2:2:end,:));
% Find the most biggest number between NW NE SW SE
y = max(a,b);
end
