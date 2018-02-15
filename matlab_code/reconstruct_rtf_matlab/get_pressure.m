function [ p ] = get_pressure( t, X, expansion_coefficients, ...
    wave_numbers_set, wave_vectors_set, wave_vectors_number, temperature )
c = 331+0.6*temperature;
p = 0;
NUMBER_OF_WAVE_NUMBERS = size(wave_numbers_set,1);
index = 1;
for wn = 1:NUMBER_OF_WAVE_NUMBERS
    wave_number = wave_numbers_set(wn);
    for wv = 1:wave_vectors_number(wn) 
        plane_wave = exp(1j*dot(X, reshape(wave_vectors_set(wn,wv,:),1,3)));
            p = p + 2*real(expansion_coefficients(index)*...
                exp(-imag(wave_number)*c*t)* ...
                exp(1j*(real(wave_number))*c*t)* ...
                plane_wave);
            index =  index + 1;
    end
end
end