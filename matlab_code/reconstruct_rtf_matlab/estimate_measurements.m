function [ EST_M ] = estimate_measurements(MES_X, MES_T, ...
    expansion_coefficients, wave_numbers, wave_vectors, wave_vectors_number, ...
    RECEIVER_NUMBER, TIME_MOMENTS, TEMPERATURE)
% estimate the measurements at the same locations and time moments
EST_M = zeros(RECEIVER_NUMBER*TIME_MOMENTS, 5);
for i = 1:RECEIVER_NUMBER
    X = MES_X(i,:);
    for j = 1:TIME_MOMENTS
        t = MES_T(j);
        p = get_pressure(t, X, expansion_coefficients, ...
            wave_numbers, wave_vectors, wave_vectors_number, TEMPERATURE);        
        EST_M((i-1)*TIME_MOMENTS+j,:) = [t X(1) X(2) X(3) p];
    end
end
end