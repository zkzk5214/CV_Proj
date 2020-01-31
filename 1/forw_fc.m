function [y] = forw_fc(x,w,b)
% Input:       x An matrix of size M * N
%              w An matrix of size M * N
%              b A scalar bias value 
% Output:      y An scalar value

sum = 0;

% y = summation(wij*xij) + b
for X = 1:size(x,1)
    for Y = 1:size(x,2)
        
        sum = sum + x(X,Y) .* w(X,Y);
    end
end
y = sum+b;
end
