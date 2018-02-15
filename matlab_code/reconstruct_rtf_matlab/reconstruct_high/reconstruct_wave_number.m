function [frequency, damping_factor, wave_number, R] = ...
    reconstruct_wave_number(MES_T, MES_X, R, TEMPERATURE, ...
    frequency, wave_vectors)
% basic parameters
c = 331 + 0.6*TEMPERATURE;
[frequency, damping_factor] = get_damping(R, MES_T, frequency);
fprintf(1, 'Wave number - (frequency [Hz], damping): (%.2f, %.2f)\n', ...
    frequency, damping_factor); 
wave_number = (frequency*2*pi - 1j*damping_factor)/c;
[Rh, Rw] = size(R);
R = reshape(R, size(R,1)*size(R,2), 1);
dictionary = get_plane_wave_dictionary_known(wave_vectors, ...
    wave_number, c, MES_X, MES_T, Rh, Rw);

expansion_coefficients_mu = 1/2*...
    pinv([real(dictionary) -imag(dictionary)])*R;
V = size(dictionary, 2);
expansion_coefficients = zeros(2*V, 1);
expansion_coefficients(1:V) = expansion_coefficients_mu(1:V) + ...
    1j*expansion_coefficients_mu(V+1:2*V);
expansion_coefficients(V+1:2*V) = expansion_coefficients_mu(1:V) - ...
    1j*expansion_coefficients_mu(V+1:2*V);
R = R - [dictionary conj(dictionary)]*expansion_coefficients;
R = reshape(R, Rh, Rw);
end