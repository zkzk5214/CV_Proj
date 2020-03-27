function [y] = forw_softmax(x)
% Input:       An array of size M * 1 
% Output:      An array of the same size

expo = exp(x);
expo_sum = sum(exp(x));
y = expo/expo_sum;
end
