% Project Title: Joint Estimation of the Room Geometry and Modes with
% Compressed Sensing, 2018
% Author: Helena Peic Tukuljac, EPFL

clc; clear; close all
addpath('reconstruct_high')
%% Prepare the data
file_name = 'measurements_200_1kHz.mat';
file_path =  fullfile('../data/', file_name);
load(file_path)
%% Load the parameters from the low part of the algorithm
file_name = 'estimated_parameters.mat';
file_path =  fullfile('../data/', file_name);
load(file_path)

%% Result buffers
SNR = [];
Pearson_correlation = [];
MAX_F = 200; % it should be adjusted to file name

%%
TIME_MOMENTS = size(measurements, 1)/RECEIVER_NUMBER;
true_resonant_frequencies = sort(real(wave_numbers_set)*c/2/pi);
mic_num = [12, 16, 19, 24, 28, 34]; % since we should compare with:
% Low Frequency Interpolation of Room Impulse Responses Using Compressed Sensing

figure('units','normalized','outerposition',[0 0 1 1])
figure_index = 1;
for RECEIVER_NUMBER = mic_num
    fprintf(1, 'Current number of receivers: %d\n', RECEIVER_NUMBER)
    [MES_X_TRAINING, MES_T_TRAINING, MES_P_TRAINING] = read_measurements ...
        (measurements, TIME_MOMENTS, RECEIVER_NUMBER);
    [R] = clean_data(MES_P_TRAINING, TEMPERATURE, MES_T_TRAINING, MES_X_TRAINING);
    %% form of the room mode data:
    % (1 resonant_frequency, 1 mode_damping, 8 wave_vectors,8 expansion_coefficients
    [resonant_frequencies_set, wave_vectors_set, wave_vectors_number] = ...
        get_approx_frequencies_and_wave_vectors(Lx, Ly, Lz, c, MAX_F);
    damping_factors_set = [];
    wave_numbers_set = [];
    for i = 1:length(resonant_frequencies_set)
        [frequency, damping_factor, wave_number, R] = ...
            reconstruct_wave_number(MES_T_TRAINING, MES_X_TRAINING, R, TEMPERATURE, ...
            resonant_frequencies_set(i), reshape(wave_vectors_set(i,1:wave_vectors_number(i), :), ...
            [wave_vectors_number(i), 3]));
        damping_factors_set = [damping_factors_set; damping_factor];
        wave_numbers_set = [wave_numbers_set; wave_number];
    end
    %% expansion coefficient reconstruction
    [expansion_coefficients] = reconstruct_expansion_coefficients...
        (measurements, wave_numbers_set, wave_vectors_set, ...
        wave_vectors_number, RECEIVER_NUMBER, TIME_MOMENTS, TEMPERATURE);
    %% Reconstruct signals at the new locations
    [MES_X_ESTIMATION, MES_T_ESTIMATION, MES_P_EVALUATION] = read_measurements ...
        (measurements, TIME_MOMENTS, 40);
    TEST_MICROPHONE_NUMBER = 32; % select one microphone for computing the SNR and PCC
    MES_X_ESTIMATION = MES_X_ESTIMATION(TEST_MICROPHONE_NUMBER, :);
    MES_P_EVALUATION = MES_P_EVALUATION(:, TEST_MICROPHONE_NUMBER);
    [MES_P_ESTIMATION] = estimate_measurements(MES_X_ESTIMATION, ...
        MES_T_ESTIMATION, expansion_coefficients, ...
        wave_numbers_set, wave_vectors_set, wave_vectors_number, 1, ...
        length(MES_T_ESTIMATION), TEMPERATURE);
    s_original = MES_P_EVALUATION;
    s_interpolated = MES_P_ESTIMATION(:, 5);
    current_snr = 20*log10(norm(s_original, 'fro')/(norm(s_original-s_interpolated, 'fro')));
    current_Pearson_correlation = 100*abs(s_original'*s_interpolated)/(norm(s_original, 'fro')*norm(s_interpolated, 'fro'));
    fprintf(1, '\n\nNumber of microphones: %d SNR: %f\n', RECEIVER_NUMBER, current_snr)
    fprintf(1, 'Number of microphones: %d Pearson correlation: %f\n\n', RECEIVER_NUMBER, current_Pearson_correlation)
    SNR = [SNR; current_snr];
    Pearson_correlation = [Pearson_correlation; current_Pearson_correlation];
    %%
    subplot(2, 3, figure_index)
    plot(MES_T_ESTIMATION, s_original, 'm')
    hold on
    plot(MES_T_ESTIMATION, s_interpolated, 'c')
    legend('original', 'estimation')
    figure_title = sprintf('%d microphones', RECEIVER_NUMBER);
    title(figure_title)
    figure_index = figure_index + 1;
end
%%
compare_results(mic_num, Pearson_correlation, SNR)