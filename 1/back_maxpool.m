function dzdx = back_maxpool(x,y,dzdy)
% Input:       x An matrix of size 2M * 2N
%              y An matrix of size M * N
%              dzdy An matrix of size M * N 
% Output:      An matrix of size 2M * 2N

[m,n] = size(y);
dzdx = zeros(2*m,2*n);
for i = 1:m 
    for j = 1:n
        for k = 1:4
            k1 = floor((k+1)/2)-1;
            k2 = mod(k+1,2);
            if y(i,j) == x(2*i-1+k1,2*j-1+k2)
               dzdx(2*i-1+k1,2*j-1+k2) = dzdy(i,j);
            else
               dzdx(2*i-1+k1,2*j-1+k2) = 0;  
           end
        end
    end
end
