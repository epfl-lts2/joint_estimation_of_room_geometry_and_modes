function [Lx_estim, Ly_estim, Lz_estim] = estimate_room_shape...
    (Lx_true, Ly_true, Lz_true, wave_vectors_set, wave_numbers_set, c)
a = wave_vectors_set(:, 1, :);
a = abs(a);
a = reshape(a, size(a, 1), size(a, 3));
a(a<0.25) = 0;
% first we find the indices of each of the basic axial room mode
fx = Inf; fy = Inf; fz = Inf;
Lx_estim = 0; Ly_estim = 0; Lz_estim = 0;
for i = 1:size(a, 1)
    if(sum(a(i,:) > 0) == 1)
        [~,col] = find(a(i,:));
        %f = a(i,col)/2/pi*c;
        f = real(wave_numbers_set(i))/2/pi*c;
        if((col == 1) && (fx > f))
            Lx_estim = c/2/f;
            fx = f;
        elseif((col == 2) && (fy > f))
            Ly_estim = c/2/f;
            fy = f;
        elseif(fz > f)
            Lz_estim = c/2/f;
            fz = f;
         end
    end
end
fprintf(1, 'True room shape: \t\t%.2f x  %.2f x  %.2f\n', Lx_true, Ly_true, Lz_true);
fprintf(1, 'Estimated room shape: \t%.2f x  %.2f x  %.2f\n', Lx_estim, Ly_estim, Lz_estim);
fprintf(1, 'Basic axial resonant frequencies: (%.2f,  %.2f,  %.2f) Hz\n', fx, fy, fz);