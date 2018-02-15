function [ ] = print_mode_type(frequency, wave_vector, ground_truth)
mode_type_estim = 'Detected mode type:\t\t';
mode_type_real = 'Real mode type:\t\t';
% we will scale with the maximum component to see how big are the others
% relative to that wave_vector = wave_vector/max(abs(wave_vector));
THRESHOLD = 0.2;
wave_vector = round(wave_vector, 1);
ground_truth = round(ground_truth, 1);
[~, index] = min(abs(ground_truth(:,1) - frequency));
fprintf('Detected frequency: \t\t%.2f\n', frequency);
fprintf('Ground truth frequency: \t%.2f\n', ground_truth(index, 1));
fprintf('Detected wave vector: \t(%.1f,%.1f,%.1f)\n', ...
    wave_vector(1), wave_vector(2), wave_vector(3));
fprintf('Ground truth wave vector: \t(%.1f,%.1f,%.1f)\n\n', ...
    ground_truth(index, 2), ground_truth(index, 3), ground_truth(index, 4));
if(ground_truth(index, 2) ~= 0)
    mode_type_real = strcat(mode_type_real, 'X');
end
if(ground_truth(index, 3) ~= 0)
    mode_type_real = strcat(mode_type_real, 'Y');
end
if(ground_truth(index, 4) ~= 0)
    mode_type_real = strcat(mode_type_real, 'Z');
end

if(abs(wave_vector(1))> THRESHOLD)
    mode_type_estim = strcat(mode_type_estim, 'X');
end
if(abs(wave_vector(2))> THRESHOLD)
    mode_type_estim = strcat(mode_type_estim, 'Y');
end
if(abs(wave_vector(3))> THRESHOLD)
    mode_type_estim = strcat(mode_type_estim, 'Z');
end
mode_type_estim = strcat(mode_type_estim, ' mode\n');
fprintf(2,mode_type_estim)
mode_type_real = strcat(mode_type_real, ' mode\n');
fprintf(2,mode_type_real)
end

