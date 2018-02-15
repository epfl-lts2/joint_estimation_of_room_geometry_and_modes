function [resonant_frequencies_set, wave_vectors_set, wave_vectors_number] = ...
    get_approx_frequencies_and_wave_vectors(Lx, Ly, Lz, c, MAX_F)
resonant_frequencies_set = [];
wave_vectors_set = [];
wave_vectors_number = [];
index = 0;
for nx = 0:5
    for ny = 0:5
        for nz = 0:5
            if((nx == 0) && (ny == 0) && (nz == 0))
                continue;
            end
            kx = nx/Lx; ky = ny/Ly; kz = nz/Lz;
            current_resonant_frequency = c/2*sqrt(kx^2 + ky^2 + kz^2);
            if(current_resonant_frequency <= MAX_F)
                index = index + 1;
                resonant_frequencies_set = [resonant_frequencies_set; current_resonant_frequency];            
                coeffmat = [1 1 1; 1 1 -1; 1 -1 1; -1 1 1];
                coeffmat = [coeffmat; -coeffmat];
                wave_vectors = coeffmat.*repmat([kx, ky, kz],8,1);
                wave_vectors = union(wave_vectors, wave_vectors, 'rows');
                wave_vectors_set(index, :, :) = zeros(8, 3);
                wave_vectors_set(index, 1:size(wave_vectors, 1), :) = wave_vectors;
                wave_vectors_number = [wave_vectors_number; size(wave_vectors, 1)];
%                 scatter3(kx, ky, kz)
%                 hold on
            end
        end
    end
end
% [~, indices] = sort(resonant_frequencies_set);
% % reorder accoring to the increasing resonant frequency
% resonant_frequencies_set = resonant_frequencies_set(indices);
% wave_vectors_set = wave_vectors_set(indices,:,:);
% wave_vectors_number = wave_vectors_number(indices);