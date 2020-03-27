function [dzdx] = back_meanpool(x,y,dzdy)
% Input:       x An matrix of size 2M * 2N
%              y An matrix of size M * N
%              dzdy An matrix of size M * N
% Output:      dzdx An matrix of size 2M * 2N

[m,n] = size(y);	% Array dzdy size M * N
dzdx = zeros(2*m,2*n);  % Set the fixed size to dydx 2M * 2N

for i = 1:m
    for j = 1:n
        for k = 1:4
            % k1,k2 = (0,0),(0,1),(1,0),(1,1)
            k1 = floor((k+1)/2)-1;
            k2 = mod(k+1,2);
            % dydx = 1/4
            dzdx(2*i-1+k1,2*j-1+k2) = 1/4 * dzdy(i,j);
        end
    end
end
