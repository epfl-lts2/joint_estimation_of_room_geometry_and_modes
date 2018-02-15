function [ angles ] = get_sample_angles_on_sphere ...
    ( NUMBER_OF_POSITIVE_SAMPLES )

% number of samples on the whole sphere; uniform samples
TOTAL_SAMPLES = 8*NUMBER_OF_POSITIVE_SAMPLES;
% uniform samples on the sphere
visualize_sphere_sampling = false;
[V,~] = get_samples_on_sphere(TOTAL_SAMPLES,visualize_sphere_sampling);

angles = [];
% extract the samples from the positive octant
for i = 1:length(V(:,1))
    if((V(i,1) >= 0) && (V(i,2) >= 0) && (V(i,3) >= 0))
        % for each point we need to determine the azimuth and 
        % the inclination angle
        % these are on the unit radius ball
        theta = acos(V(i,3)); % inclination
        phi = atan(V(i,2)/V(i,1)); % azimuth
        angles = [angles; [theta phi]];
    end
end
angles(isnan(angles)) = 0;
end