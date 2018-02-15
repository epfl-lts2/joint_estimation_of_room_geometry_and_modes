function [ ground_truth ] = get_theoretical_ground_truth(Lx, Ly, Lz, N, temperature, ...
    max_freq)
max_freq = max_freq + 20;
c = 331+0.6*temperature;
et = zeros(N+1, N+1, N+1);
axial = [];
tangential = [];
oblique = [];
ground_truth = [];
for nx = 0:N
    for ny = 0:N
        for nz = 0:N
            f = c/2*sqrt((nx/Lx)^2 + (ny/Ly)^2 + (nz/Lz)^2);
            if((f < max_freq) && (f ~= 0))
                switch(nnz([nx, ny, nz]))
                    case 3
                        oblique = [oblique f];
                    case 2
                        tangential = [tangential f];
                    case 1
                        axial = [axial f];
                    otherwise
                end
                et(nx+1, ny+1, nz+1) = f;
                ground_truth = [ground_truth; [f pi*nx/Lx pi*ny/Ly pi*nz/Lz]];
            end
        end
    end
end
ground_truth = sortrows(ground_truth, 1);
axial = sort(axial);
tangential = sort(tangential);
oblique = sort(oblique);

end