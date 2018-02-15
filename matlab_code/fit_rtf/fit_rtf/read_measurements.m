function [ MES_X, MES_T, MES_P ] = read_measurements( mes, TIME_MOMENTS, ...
   RECEIVER_NUMBER )
% coordinates of measurements
MES_X = mes(1:TIME_MOMENTS:TIME_MOMENTS*RECEIVER_NUMBER,2:4);
% sampling time moments
MES_T = mes(1:TIME_MOMENTS,1);
% measurements: one row per time moment; one column per microphone position
MES_P = zeros(TIME_MOMENTS, RECEIVER_NUMBER);
for i = 1:RECEIVER_NUMBER
    MES_P(:,i) = mes((i-1)*TIME_MOMENTS+1:i*TIME_MOMENTS,5);
end
end