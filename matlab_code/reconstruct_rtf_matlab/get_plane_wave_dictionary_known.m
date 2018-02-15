function [ dictionary_plane_waves, wave_dictionary ] = get_plane_wave_dictionary_known( ...
    wave_dictionary, wave_number, c, MES_X, MES_T, TIME_MOMENTS, RECEIVER_NUMBER )
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
% normalize the atoms (columns of the dictionary)
for i = 1:size(dictionary_plane_waves,2)
    dictionary_plane_waves(:,i) = dictionary_plane_waves(:,i)/ ...
        norm(dictionary_plane_waves(:,i));
end
end