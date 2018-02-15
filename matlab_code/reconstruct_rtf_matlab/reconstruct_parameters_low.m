% Project Title: Joint Estimation of the Room Geometry and Modes with
% Compressed Sensing, 2018
% Author: Helena Peic Tukuljac, EPFL

clc; clear; close all
file_name = 'measurements_70.mat';
%% Prepare the data
file_path =  fullfile('../data/', file_name);
load(file_path)
addpath('./plot_methods')
%% Approximate ground truth
addpath(genpath('../fit_rtf'))
[frequency_fitted, damping_fitted] = fit_rtf(file_name);

%% Estimation parameters
fprintf(1, '*In order to change the precision, change the NUMBER_OF_POSITIVE_SAMPLES parameter\n\n');
NUMBER_OF_POSITIVE_SAMPLES = 100;  % the PRECISION highly depends on the number of samples on the sphere
% this is the number of samples in the positive octant
TIME_MOMENTS = size(measurements, 1)/RECEIVER_NUMBER;
RECEIVER_NUMBER = 35;
NUMBER_OF_ITERATIONS = ceil(get_number_of_eigenfrequencies_below_frequency ...
  (F_MAX, Lx, Ly, Lz, TEMPERATURE));        % can be replaced by an approximation
fprintf(1, 'Number of wave numbers to be estimated: %d\n', NUMBER_OF_ITERATIONS);
ANGLES = get_sample_angles_on_sphere_quarter(NUMBER_OF_POSITIVE_SAMPLES);
theoretical_ground_truth = get_theoretical_ground_truth(Lx, Ly, Lz, N, TEMPERATURE, F_MAX);

%% Loading and cleaning the data
[MES_X_TRAINING, MES_T_TRAINING, MES_P_TRAINING] = read_measurements ...
    (measurements, TIME_MOMENTS, RECEIVER_NUMBER);
[MES_P_TRAINING] = clean_data(MES_P_TRAINING, TEMPERATURE, MES_T_TRAINING, MES_X_TRAINING);

%% Data buffers
fprintf(1, 'Initial residual: %f\n\n', norm(MES_P_TRAINING, 'fro'));
N = 8;                                                             % wave vectors per wave number
wave_numbers_set = zeros(NUMBER_OF_ITERATIONS, 1);
wave_vectors_set = zeros(NUMBER_OF_ITERATIONS, N, 3);
wave_vectors_number = [];                        % it can be 2 or 4 or 8 based on the type of the room mode

%% THE PARAMETER ESTIMATION PROCEDURE
R = MES_P_TRAINING;
R_original = MES_P_TRAINING;
for i = 1:NUMBER_OF_ITERATIONS
    fprintf(1, '%d. wave number\n', i);
    [wave_number, wave_vectors, R] = ...
        reconstruct_wave_number_and_wave_vectors...
        (MES_T_TRAINING, MES_X_TRAINING, R, R_original, TEMPERATURE, REVERBERATON_TIME_60, ...
        ANGLES, SAMPLING_FREQUENCY, wave_numbers_set, wave_vectors_set, wave_vectors_number);

    if (~isempty(wave_vectors) && real(wave_number) > 0)
        wave_numbers_set(i) = wave_number;
        wave_vectors_set(i,1:size(wave_vectors,1),:) = wave_vectors;
        wave_vectors_number = [wave_vectors_number size(wave_vectors, 1)];
    end
    fprintf(1, 'Residual norm for the next iteration: %f\n\n', norm(R, 'fro'));
end        

%% Show and save the results
plot_wave_vector_lattice(theoretical_ground_truth, wave_vectors_set, wave_numbers_set)
c = 331 + 0.6*TEMPERATURE;
[Lx, Ly, Lz] = estimate_room_shape(Lx, Ly, Lz, wave_vectors_set, wave_numbers_set, c);
MAX_F = SAMPLING_FREQUENCY/2;
save('../data/estimated_parameters.mat', 'Lx', 'Ly', 'Lz', 'MAX_F', 'c', ...
    'wave_numbers_set', 'wave_vectors_set', 'wave_vectors_number', ...
    'theoretical_ground_truth');