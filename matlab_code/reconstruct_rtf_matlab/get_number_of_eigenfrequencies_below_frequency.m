function [ N ] = get_number_of_eigenfrequencies_below_frequency ...
    ( f, Lx, Ly, Lz, TEMPERATURE )
% Room Acoustics Book - H. Kuttruff - page 78 - (3.20a)
c = 331 + 0.6*TEMPERATURE;
V = Lx*Ly*Lz;
S = 2*(Lx*Ly+Lx*Lz+Ly*Lz);
L = 4*(Lx+Ly+Lz);
NV = 4/3*pi*V*(f/c)^3;
NS = pi/4*S*(f/c)^2; % shared by two octants
NL = L/8*f/c;             % shared by four octants
N = NV+NS+NL;
end

