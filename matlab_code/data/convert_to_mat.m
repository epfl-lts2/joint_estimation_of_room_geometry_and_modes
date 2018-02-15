clear
Lx = 3;
Ly = 5.6;
Lz = 3.53;
RECEIVER_NUMBER = 66*2;
REVERBERATON_TIME_60 = 2.8;
TEMPERATURE = 25;
N = 3; % for estimation of room modes
WALL_IMPEDANCES = 0.01*ones(6, 1);
% we need to cut the first 3 seconds out of 7s in the signal
%% to be adjusted
F_MAX = 150;
SAMPLING_FREQUENCY = 400;
%%
load 'netdb_measurements_training_150_400Hz.dat'
load 'netdb_measurements_evaluation_150_400Hz.dat'
one_measurement_length = ...
    size(netdb_measurements_evaluation_150_400Hz, 1)/(RECEIVER_NUMBER/2);
new_measurement_length = 3*SAMPLING_FREQUENCY;

new_netdb_measurements_training_150_400Hz = [];
microphone_positions = netdb_measurements_training_150_400Hz(1:one_measurement_length:end,2:4);
indices_training = (microphone_positions(:,2)>0.3 & microphone_positions(:,1)<1.5 & microphone_positions(:,2)<3);
indices_training = find(indices_training);
for i = 1:length(indices_training)
    index = indices_training(i);
    index_start = round((index - 1)*one_measurement_length + 1);
    index_end = index_start + new_measurement_length - 1;
    new_netdb_measurements_training_150_400Hz = ...
        [new_netdb_measurements_training_150_400Hz; ...
        netdb_measurements_training_150_400Hz(index_start:index_end, :) ];
end
new_netdb_measurements_evaluation_150_400Hz = [];
microphone_positions = netdb_measurements_evaluation_150_400Hz(1:one_measurement_length:end,2:4);
indices_evaluation = (microphone_positions(:,2)>0.3 & microphone_positions(:,1)<1.5 & microphone_positions(:,2)<3);
indices_evaluation = find(indices_evaluation);
for i = 1:length(indices_evaluation)
    index = indices_evaluation(i);
    index_start = round((index - 1)*one_measurement_length + 1);
    index_end = index_start + new_measurement_length - 1;
    new_netdb_measurements_evaluation_150_400Hz = ...
        [new_netdb_measurements_evaluation_150_400Hz; ...
        netdb_measurements_evaluation_150_400Hz(index_start:index_end, :) ];
end
measurements = [new_netdb_measurements_training_150_400Hz; ...
   new_netdb_measurements_evaluation_150_400Hz];
RECEIVER_NUMBER = length(indices_training) + length(indices_evaluation);
clear i
clear indices_training
clear indices_evaluation
clear microphone_positions
clear one_measurement_length
clear new_measurement_length
clear new_netdb_measurements_evaluation_150_400Hz
clear new_netdb_measurements_training_150_400Hz
clear netdb_measurements_evaluation_150_400Hz
clear netdb_measurements_training_150_400Hz
clear index_start
clear index_end
save('measurements_150_400Hz.mat')
clear