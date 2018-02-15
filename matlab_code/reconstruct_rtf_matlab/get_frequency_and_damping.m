function [ frequency, damping_factor ] = get_frequency_and_damping( R, ...
    MES_T, REVERBERATON_TIME_60, SAMPLING_FREQUENCY)
DAMPING_CONSTANT = -3*log(10)/REVERBERATON_TIME_60;
DAMPING_FACTOR_MIN = 2*DAMPING_CONSTANT;
DAMPING_FACTOR_MAX = 0.5*DAMPING_CONSTANT;
DAMPING_STEP = 0.01;
DAMPING_VECTOR = DAMPING_FACTOR_MIN:DAMPING_STEP:DAMPING_FACTOR_MAX;

FREQUENCY_STEP = 0.1;
FREQUENCY_VECTOR = 0:FREQUENCY_STEP:(SAMPLING_FREQUENCY-FREQUENCY_STEP);

FFT_SIZE = length(FREQUENCY_VECTOR);
FFTS = zeros(length(DAMPING_VECTOR), FFT_SIZE, size(R,2));

DAMPING_VECTOR_TIME = exp(kron(DAMPING_VECTOR,MES_T));
for n = 1:length(DAMPING_VECTOR)     % per every damping factor
  DAMPING_VECTOR_TIME(:,n) = DAMPING_VECTOR_TIME(:,n)/norm(DAMPING_VECTOR_TIME(:,n), 'fro') ;
end

for n = 1:length(DAMPING_VECTOR)     % per every damping factor
    for j = 1:size(R,2)                                  % per every receiver
        FFTS(n,:,j) = fft(DAMPING_VECTOR_TIME(:,n).*R(:,j), FFT_SIZE);
    end
end

FFTS_HALF = FFTS(:,1:FFT_SIZE/2,:);
sums = sum(abs(FFTS_HALF),3);              % sum over the receivers
[~, index] = max(sums(:));
[damp_index, freq_index] = ind2sub(size(sums), index);
frequency = FREQUENCY_VECTOR(freq_index);
damping_factor = DAMPING_VECTOR(damp_index);
end