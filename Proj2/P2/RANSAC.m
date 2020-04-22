function [Translation,MaxInliers,pair0,pair1] = RANSAC(p, e, s, data, epsilon)
% p: desire probability that we get a good sample
% e: probability that a point is an outlier
% N: number of samples we want
% s: number of points in a sample

% Calculate number of loops N
N = ceil(log(1 - p) / log(1 - (1-e)^s)); 

NPoints = size(data, 1);
MaxInliers = 0;

A = zeros(2*s, 2);
b = zeros(2*s, 1);

for i = 1:s
    A(2*i-1,1) = 1;
    A(2*i,2) = 1;
end

for i = 1:N
    sampleIndicies = randperm(NPoints, s);    
    samples = data(sampleIndicies,:,:);
    
    pair0=samples(:,:,1);
    pair1=samples(:,:,2);

    for j = 1:s
        b(2*j-1) = pair0(j,1)-pair1(j,1);
        b(2*j) = pair0(j,2)-pair1(j,2);
    end
    
    % [tx,ty]
    t = A \ b;
    Translation = [1 0 t(1); 0 1 t(2); 0 0 1];
    
    p_prime = Translation * data(:,:,2)';
    error = data(:,:,1)' - p_prime;
    SE = error .^ 2;
    SSE = sum(SE);
    numInliers=sum(SSE<epsilon);
    
    % if better
    if numInliers > MaxInliers
        bestSet = find(SSE<epsilon);
        MaxInliers = numInliers;
    end
end


% Recompute transform use inliers 
pair0=data(bestSet,:,1);
pair1= data(bestSet,:,2);

for j = 1:s
    b(2*j-1) = pair0(j,1)-pair1(j,1);
    b(2*j) = pair0(j,2)-pair1(j,2);
end

t = A \ b;
Translation = [1 0 t(1); 0 1 t(2); 0 0 1];

end