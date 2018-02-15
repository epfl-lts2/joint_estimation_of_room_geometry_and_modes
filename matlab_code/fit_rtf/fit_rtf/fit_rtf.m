function [fn, xin] = fit_rtf(file_name)
full_path =  fullfile('../data/', file_name);
load(full_path)
TIME_MOMENTS = size(measurements,1)/RECEIVER_NUMBER;
[~, MES_T, MES_P] = read_measurements(measurements, TIME_MOMENTS, ...
   RECEIVER_NUMBER);
% MES_P is of size MES_T x RECEIVER_NUMBER
f_step = SAMPLING_FREQUENCY/length(MES_T);
f = 0:f_step:(SAMPLING_FREQUENCY-f_step);
f = f';
H = fft(MES_P); % we need to compute the fft over columns
H = H(:, 1:15);
[fn, xin] = curve_fitting(H, f);