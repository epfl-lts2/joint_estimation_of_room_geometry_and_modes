function [ wave_number, wave_vectors, R ] = ...
    reconstruct_wave_number_and_wave_vectors ...
        (MES_T, MES_X, R, R_original, TEMPERATURE, REVERBERATON_TIME_60, ...
        ANGLES, SAMPLING_FREQUENCY, wave_numbers_set, wave_vectors_set, wave_vectors_number)
% basic parameters
c = 331 + 0.6*TEMPERATURE;
%% reconstruct wave number
[frequency, damping_factor] = get_frequency_and_damping(R, MES_T, ...
    REVERBERATON_TIME_60, SAMPLING_FREQUENCY);
wave_number = (frequency*2*pi - 1j*damping_factor)/c;
fprintf(1, 'Wave number - (frequency [Hz], damping): (%.2f, %.2f)\n', ...
    frequency, damping_factor); 

if (frequency > 0) % we cannot have a ball with radius 0
    %% compute the new vectorized residual
    [Rh, Rw] = size(R);
    R = reshape(R, Rh*Rw, 1);
    [wave_vectors] = reconstruct_wave_vectors ...
        (R, wave_number, ANGLES, c, MES_X, MES_T, Rh, Rw);
        
    dictionary = get_plane_wave_dictionary_known(wave_vectors, ...
        wave_number, c, MES_X, MES_T, Rh, Rw);
    if(~isempty(wave_vectors_number))
        for i = 1:length(wave_vectors_number)
            current_wave_vectors = reshape ...
                (wave_vectors_set(i,1:wave_vectors_number(i),:), ...
                [wave_vectors_number(i), 3]);
            dictionary_new = get_plane_wave_dictionary_known...
                (current_wave_vectors, wave_numbers_set(i), c, MES_X, MES_T, Rh, Rw);
            dictionary = [dictionary dictionary_new];
        end
    end
    R_original = reshape(R_original, Rh*Rw, 1);
    % optimized expansion coefficient calculation
    expansion_coefficients_mu = 1/2*...
        pinv([real(dictionary) -imag(dictionary)])*R_original;
    V = size(dictionary, 2);
    expansion_coefficients = zeros(2*V, 1);
    expansion_coefficients(1:V) = expansion_coefficients_mu(1:V) + ...
        1j*expansion_coefficients_mu(V+1:2*V);
    expansion_coefficients(V+1:2*V) = expansion_coefficients_mu(1:V) - ...
        1j*expansion_coefficients_mu(V+1:2*V);
    R = R_original - [dictionary conj(dictionary)]*expansion_coefficients;
    R = reshape(R, Rh, Rw);
else
    wave_vectors = [];
end
end