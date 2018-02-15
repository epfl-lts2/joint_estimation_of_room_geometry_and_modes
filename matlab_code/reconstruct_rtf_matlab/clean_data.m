function [ MES_P_cleaned ] = clean_data( R, TEMPERATURE, MES_T, MES_X)
% this script is used to clean the measurments from false modes
% that exist in the measurements and that are not due to the room behavior
% but due to the fire extinguishing pipe that exists inside
c = 331 + 0.6*TEMPERATURE;
frequency = 42.33;
damping_factor = -2.4;
wave_number = (frequency*2*pi - 1j*damping_factor)/c;
% remove the false mode from the measurements
[Rh, Rw] = size(R);
R = reshape(R, size(R,1)*size(R,2), 1);
wave_vectors = [real(wave_number) 0 0; -real(wave_number) 0 0]; % axial wave vector along the longer side of the room
dictionary = get_plane_wave_dictionary_known(wave_vectors, ...
    wave_number, c, MES_X, MES_T, Rh, Rw);
% optimized expansion coefficient calculation
expansion_coefficients_mu = 1/2*...
    pinv([real(dictionary) -imag(dictionary)])*R;
V = size(dictionary, 2);
expansion_coefficients = zeros(2*V, 1);
expansion_coefficients(1:V) = expansion_coefficients_mu(1:V) + ...
    1j*expansion_coefficients_mu(V+1:2*V);
expansion_coefficients(V+1:2*V) = expansion_coefficients_mu(1:V) - ...
    1j*expansion_coefficients_mu(V+1:2*V);
R = R - [dictionary conj(dictionary)]*expansion_coefficients;
MES_P_cleaned = reshape(R, Rh, Rw);
end