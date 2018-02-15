function [ expansion_coefficients ] = reconstruct_expansion_coefficients...
    ( measurements, wave_numbers, wave_vectors, wave_vectors_number, ...
    RECEIVER_NUMBER, TIME_MOMENTS, TEMPERATURE )
[MES_X, MES_T, MES_P] = read_measurements(measurements, TIME_MOMENTS, ...
    RECEIVER_NUMBER);
c = 331 + 0.6*TEMPERATURE;
NUMBER_OF_WAVE_VECTORS = sum(wave_vectors_number);
dictionary = zeros(TIME_MOMENTS*RECEIVER_NUMBER, NUMBER_OF_WAVE_VECTORS);
NUMBER_OF_WAVE_NUMBERS = size(wave_numbers,1);

for m = 1:RECEIVER_NUMBER
    for n = 1:TIME_MOMENTS
        for wn = 1:NUMBER_OF_WAVE_NUMBERS
            wave_number = wave_numbers(wn);       
            for wv = 1:wave_vectors_number(wn)    
                index = sum(wave_vectors_number(1:(wn-1)))+wv;
                plane_wave = exp(1j*dot(MES_X(m,:), ...
                    reshape(wave_vectors(wn,wv,:),1,3)));
                dictionary((m-1)*TIME_MOMENTS+n, index) = ...
                    exp(1j*wave_number*c*MES_T(n))* ...
                    plane_wave;                    
            end
        end
    end
end

% here we have to use the vectorized measurements
MES_P = reshape(MES_P, size(MES_P,1)*size(MES_P,2), 1);
% optimized expansion coefficient calculation
expansion_coefficients_mu = 1/2*...
    pinv([real(dictionary) -imag(dictionary)])*MES_P;
V = size(dictionary, 2);
expansion_coefficients = zeros(2*V, 1);
expansion_coefficients(1:V) = expansion_coefficients_mu(1:V) + ...
    1j*expansion_coefficients_mu(V+1:2*V);
expansion_coefficients(V+1:2*V) = expansion_coefficients_mu(1:V) - ...
    1j*expansion_coefficients_mu(V+1:2*V);
% this is equivalent:
%expansion_coefficients = pinv([dictionary conj(dictionary)])*MES_P;
end