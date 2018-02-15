function [fn, xin] = curve_fitting(H, f)
% Input:
% H: transfer function in complex from the measured electrical signal
% f: frequency vector
% Output:
% resonant frequencies
% mode dampings
for k = 1:size(H,2)
	H(:,k) = smooth(-H(:,k));
end

% Font for figures
FS = 15; FN_H = 'Helvetica'; LW = 1.2; FN_T = 'Arial';
num_params = [-60, 4, 76]; % we need to tweak these parameters

[ P] = plot_fitted_transfer_functions( f, H, FS, FN_H, num_params );
%plot_poles(P, FS, FN_T)
%fprintf(1, 'Ground truth frequencies and dampings estimated by curve fitting:\n');
%for i = 2:size(P, 1)
%    fprintf(2, 'Frequency [Hz]: %f, damping: %f\n', imag(P(i)), real(P(i)))
%end
fn = imag(P(2:end))';
xin = -real(P(2:end))';