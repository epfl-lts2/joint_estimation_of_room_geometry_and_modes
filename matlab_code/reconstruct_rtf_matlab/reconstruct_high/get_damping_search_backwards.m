function [ frequency, damping_factor ] = get_damping2 ...
    (R, MES_T, frequency)
DAMPING_STEP = 0.01;
DAMPING_FACTOR_MAX=-0.5;
DAMPING_FACTOR_MIN=-20;
DAMPING_VECTOR = DAMPING_FACTOR_MIN:DAMPING_STEP:DAMPING_FACTOR_MAX;

% we need to search the surrounding of the 
STEP = 0.5;
HALF_RANGE = 1;
FREQUENCY_VECTOR = (frequency-HALF_RANGE):STEP:(frequency+HALF_RANGE); % looking backwards for the closest peak

DAMPING_VECTOR_TIME = exp(kron(DAMPING_VECTOR,MES_T));
DICTIONARY = zeros(length(MES_T), length(DAMPING_VECTOR), length(FREQUENCY_VECTOR));

for f = 1:length(FREQUENCY_VECTOR)
    for n = 1:length(DAMPING_VECTOR)     % per every damping factor
      DICTIONARY(:,n,f) = DAMPING_VECTOR_TIME(:,n)./norm(DAMPING_VECTOR_TIME(:,n), 'fro') ;
      DICTIONARY(:,n,f) = DICTIONARY(:,n).*exp(1j*2*pi*FREQUENCY_VECTOR(f)*MES_T);
    end
end

expansion = zeros(size(DICTIONARY));
for f = 1:length(FREQUENCY_VECTOR)      % per every frequency factor
    for n = 1:length(DAMPING_VECTOR)     % per every damping factor
        for j = 1:size(R,2)                                  % per every receiver
            expansion(:,n,f) = expansion(:,n,f) + abs(DICTIONARY(:,n,f)'*R(:,j));
        end
    end
end
% the times are over dim 1
% the dampings are over dim 2
% the frequencies are over dim 3
expansion_sum = sum(expansion, 1); % sum over time
expansion_sum = reshape(expansion_sum, size(expansion_sum, 2), size(expansion_sum, 3));
% sum over frequency to get damping
expansion_sum_damp = sum(expansion_sum, 2);
[~, index] = max(expansion_sum_damp);
damping_factor = DAMPING_VECTOR(index);
% sum over damping to get frequency
expansion_sum_freq = sum(expansion_sum, 1);
[~, index] = max(expansion_sum_freq);
frequency = FREQUENCY_VECTOR(index);
end