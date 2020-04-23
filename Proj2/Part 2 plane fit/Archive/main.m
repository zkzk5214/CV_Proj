params = struct;
params.inlier_threshold = 0.05;      % in meters
params.min_sample_dist = 0.1;    % in meters
params.confidence = 0.90;
params.error_func = @ransac_error;
[a,b,c,d,inliers,k] = fit_plane(p, params);


function [error, inliers] = ransac_error(~, distances, threshold)
    inliers = find(distances < threshold);
    outliers = distances >= threshold;
    error = 0* sum(distances(inliers).^2) + 1*sum(distances(outliers).^2);
end
