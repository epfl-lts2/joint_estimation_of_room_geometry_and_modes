function [ dictionary_plane_waves] = get_plane_wave_dictionary( ...
    plane_wave, wave_number, c, MES_X, MES_T, TIME_MOMENTS, RECEIVER_NUMBER )
% construct a dictionary out of 8 wave vectors attributed to the currently
% observed mode
coeffmat = [1 1 1; 1 1 -1; 1 -1 1; -1 1 1];
coeffmat = [coeffmat; -coeffmat];
wave_dictionary = coeffmat.*repmat(plane_wave,8,1);
wave_dictionary = union(wave_dictionary, wave_dictionary, 'rows');
dictionary_plane_waves = ...
    zeros(TIME_MOMENTS*RECEIVER_NUMBER, ...
    size(wave_dictionary,1));

for k = 1:size(wave_dictionary,1)
    wave_vector = wave_dictionary(k,:);
    for j = 1:RECEIVER_NUMBER
        plane_wave = exp(1j*dot(MES_X(j,:), wave_vector));
        for i = 1:TIME_MOMENTS
            dictionary_plane_waves(i+(j-1)*TIME_MOMENTS, k) = ...
                   exp(1j*wave_number*c*MES_T(i))*...  % temporal
                   plane_wave;                                            % spatial
        end
    end
end
end